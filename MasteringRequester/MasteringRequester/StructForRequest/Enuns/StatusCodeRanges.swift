//
//  StatusCodeRanges.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

import Foundation

enum StatusCodeRanges {
    case succesRange
    case unauthorized
    
    var range: Range<Int> {
        switch self {
        case .succesRange: return Range(uncheckedBounds: (200, 299))
        case .unauthorized: return Range(uncheckedBounds: (401, 401))
        }
    }
}
