//
//  Requester.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//


import Foundation

protocol RequesterWithCompletionBlock {
    func executeRequest<E: Decodable>(
        endpoint: Endpoint,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    )
}

//MARK: - Default implementations
extension RequesterWithCompletionBlock {
    
    func executeRequest<E: Decodable>(
        endpoint: Endpoint,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    ) {
        guard let urlRequest = makeURLRequester(
            endpoint, completionHandler: completionHandler
        ) else { return }
        
        performAPI(urlRequest: urlRequest, completionHandler: completionHandler)
    }
}

//MARK: - Helpers
private extension RequesterWithCompletionBlock {
    func makeURLRequester<E: Decodable>(
        _ endpoint: Endpoint,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    ) -> URLRequest? {
        
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
    
    func performAPI<E: Decodable>(
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
            
            let json = String(data: data, encoding: .utf8)!
            print(json)
            
            handleStatusCode(
                response: response, data: data,
                completionHandler: completionHandler
            )
        }
        
        task.resume()
    }
    
    func handleStatusCode<E: Decodable>(
        response: HTTPURLResponse, data: Data,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    ) {
        switch response.statusCode {
        case StatusCodeRanges.succesRange.range:
            decodeJSON(data: data, response: response, completionHandler: completionHandler)
        case StatusCodeRanges.unauthorized.range:
            completionHandler(.failure(.unauthorized))
        default:
            completionHandler(.failure(.unexpectedStatusCode(response.statusCode)))
        }
    }
    
    func decodeJSON<E: Decodable>(
        data: Data, response: HTTPURLResponse,
        completionHandler: @escaping ((Result<E, RequesterErrors>) -> Void)
    ) {
        do {
            let decodedResponse = try JSONDecoder().decode(E.self, from: data)
            completionHandler(.success(decodedResponse))
        } catch {
            completionHandler(.failure(.decode(nil)))
        }
    }

}
