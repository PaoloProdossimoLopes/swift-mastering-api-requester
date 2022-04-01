//
//  UserEndpoint.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

struct UserEndpoint: Endpoint {
    let baseURL: String = "https://jsonplaceholder.typicode.com/users"
    let path: String = ""
    let method: HTTPMetod = .GET
    
    let header: [String : String]? = nil
    let query: [String : String]? = nil
    let body: [String : String]? = nil
}
