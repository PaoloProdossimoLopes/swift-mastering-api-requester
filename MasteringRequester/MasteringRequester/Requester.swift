//
//  Requester.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//


import Foundation

protocol Requester {
    func executeRequest<E: Decodable>(
        endpoint: Endpoint, expect: E.Type
    ) async -> Result<E, RequesterErrors>
    
    func executeRequest<E: Decodable>(
        endpoint: Endpoint, expect: E.Type,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    )
}

extension Requester {
    
    func executeRequest<E: Decodable>(
        endpoint: Endpoint, expect: E.Type,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    ) {
        
        guard let urlRequest = makeURLRequester(endpoint, completionHandler: completionHandler)
        else { return }
        
        performAPI(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    private func makeURLRequester<E: Decodable>(_ endpoint: Endpoint, completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)) -> URLRequest? {
        
        let fullURLString = endpoint.fullURLString
        
        guard let url = URL(string: fullURLString) else {
            completionHandler(.failure(.invalidURL(fullURLString)))
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let header = endpoint.header {
            request.allHTTPHeaderFields = header
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return request
    }
    
    private func performAPI<E: Decodable>(
        urlRequest: URLRequest,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    ) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.noResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            handleStatusCode(
                response: response, data: data,
                completionHandler: completionHandler
            )
        }
        
        task.resume()
    }
    
    private func decodeJSON<EXPECTED: Decodable>(
        data: Data, response: HTTPURLResponse, expect: EXPECTED.Type,
        completionHandler: @escaping ((Result<EXPECTED, RequesterErrors>) -> Void)
    ) {
        do {
            let decodedResponse = try JSONDecoder().decode(EXPECTED.self, from: data)
            completionHandler(.success(decodedResponse))
        } catch {
            completionHandler(.failure(.decode(nil)))
        }
    }
    
    private func handleStatusCode<EXPECTED: Decodable>(
        response: HTTPURLResponse, data: Data,
        completionHandler: @escaping ((Result<EXPECTED, RequesterErrors>) -> Void)
    ) {
        switch response.statusCode {
        case 200...299:
            decodeJSON(
                data: data, response: response, expect: EXPECTED.self,
                completionHandler: completionHandler
            )
        case 401:
            completionHandler(.failure(.unauthorized))
        default:
            completionHandler(.failure(.unexpectedStatusCode(response.statusCode)))
        }
    }
}
