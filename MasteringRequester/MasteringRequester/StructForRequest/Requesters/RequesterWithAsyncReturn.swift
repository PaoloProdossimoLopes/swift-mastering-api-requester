//
//  RequesterWithAsyncReturn.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

import Foundation

protocol RequesterWithAsyncReturn {
    func executeRequest<E: Decodable>(endpoint: Endpoint) async -> Result<E, RequesterErrors>
}

//MARK: - Default implementations
extension RequesterWithAsyncReturn {
    
    func executeRequest<E: Decodable>(endpoint: Endpoint) async -> Result<E, RequesterErrors> {
        
        var urlRequest: URLRequest?
        
        switch makeURLRequester(endpoint) {
        case .success(let request):
            urlRequest = request
        case .failure(let error):
            return .failure(error)
        }
        
        guard let URLRequest = urlRequest
        else { return .failure(.invalidURL("URLRequest validator")) }
        
        return await performAPI(URLRequest: URLRequest)
    }
}

//MARK: - Helpers
private extension RequesterWithAsyncReturn {
    func makeURLRequester(_ endpoint: Endpoint) -> Result<URLRequest?, RequesterErrors> {
        
        let fullURLString = endpoint.fullURLString
        
        guard let url = URL(string: fullURLString) else {
            return .failure(.invalidURL(fullURLString))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let header = endpoint.header {
            request.allHTTPHeaderFields = header
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return .success(request)
    }
    
    func performAPI<E: Decodable>(URLRequest: URLRequest) async -> Result<E, RequesterErrors> {
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest, delegate: nil)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            return handleStatusCode(data: data, statusCode: response.statusCode)
            
        } catch { return .failure(.unknowed) }
    }
    
    func decodeHandler<E: Decodable>(data: Data) -> Result<E, RequesterErrors> {
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(E.self, from: data)
            return .success(decodedResponse)
        } catch {
            let nameOfClassFailedToDecode = String.init(describing: E.self)
            return .failure(.decode(nameOfClassFailedToDecode))
        }
    }
    
    func handleStatusCode<E: Decodable>(data: Data, statusCode: Int) -> Result<E, RequesterErrors> {
        
        switch statusCode {
        case StatusCodeRanges.succesRange.range: return decodeHandler(data: data)
        case StatusCodeRanges.unauthorized.range: return .failure(.unauthorized)
        default: return .failure(.unexpectedStatusCode(statusCode))
        }
        
    }
}
