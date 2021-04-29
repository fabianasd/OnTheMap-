//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 28/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case key
    }
}
