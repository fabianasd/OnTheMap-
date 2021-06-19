//
//  CreateSessionRequest.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 18/06/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct CreateSessionRequest: Codable {
    let udacity: CreateSessionUdacityRequest
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}

struct CreateSessionUdacityRequest: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
