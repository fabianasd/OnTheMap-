//
//  logoutResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 15/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct logoutResponse: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case expiration = "expiration"
    }
}
