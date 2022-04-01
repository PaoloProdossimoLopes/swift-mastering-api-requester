//
//  Requester.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

import Foundation


protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMetod { get }
    var header: [String : String]? { get }
    var query: [String : String]? { get }
    var body: [String: String]? { get }
    var timeout: Double { get } // native default: 60.0
    var cachePolicy: NSURLRequest.CachePolicy { get } // native default: .useProtocolCachePolicy
}

extension Endpoint {
    var fullURLString: String { baseURL + path }
    var timeout: Double { 60.0 }
    var cachePolicy: NSURLRequest.CachePolicy { .useProtocolCachePolicy }
}
