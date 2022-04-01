//
//  UserResponseModel.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

import Foundation

struct UserResponseModel: Codable {
    let id: Int
    let name: String
    let username: String
    let address: UserModelAdressResponse
    let phone: String
    let website: String
    let company: UserResponseModelCompanyResponse
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case address = "address"
        case phone = "phone"
        case website = "website"
        case company = "company"
    }
}

struct UserModelAdressResponse: Codable {
    let street: String
    let suite: String
    let city: String
    let zipCode: String
    
    enum CodingKeys: String, CodingKey {
        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipCode = "zipcode"
    }
}

struct UserResponseModelCompanyResponse: Codable {
    let name: String
    let catchPhrase: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catchPhrase = "catchPhrase"
    }
}
