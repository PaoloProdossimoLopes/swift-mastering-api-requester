//
//  RequesterErrors.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

enum RequesterErrors: Error {
    case decode(_ object: String? = nil)
    case invalidURL(_ urlString: String? = nil)
    case noResponse
    case unauthorized
    case unexpectedStatusCode(_ statusCode: Int? = nil)
    case unknowed
    case noData
}

extension RequesterErrors {
    var describeError: String {
        switch self {
        case .decode(let obj): return "Error to decode the \(obj ?? "Data")."
        case .invalidURL(let urlString): return "This url (\(urlString ?? "")) is invalid."
        case .noResponse: return "No response from API."
        case .unauthorized: return "unauthorized, it is possible your sessions expired."
        case .unexpectedStatusCode(let statusCode): return "This status code \(statusCode ?? 0) was not expect."
        case .unknowed: return "Something unknowed doing bad."
        case .noData: return "No Data."
        }
    }
}
