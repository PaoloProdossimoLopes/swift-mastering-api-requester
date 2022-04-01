//
//  UserRequester.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

import Foundation

protocol UserRequesterProtocol: Requester {
    func fetchUsers(_ completion: @escaping (Result<[UserResponseModel], RequesterErrors>) -> Void)
    func fetchUserWithReturn() async -> Result<[UserResponseModel], RequesterErrors>
}

final class UserRequester: UserRequesterProtocol {
    
    typealias UserAPIResultExpect = Result<[UserResponseModel], RequesterErrors>
    
    func fetchUsers(
        _ completion: @escaping ((UserAPIResultExpect) -> Void)
    ) {
        let endpoint = UserEndpoint()
        executeRequest(endpoint: endpoint, completionHandler: completion)
    }
    
    func fetchUserWithReturn() async -> UserAPIResultExpect {
        let endpoint = UserEndpoint()
        return await executeRequest(endpoint: endpoint)
    }
}

