//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 04/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct SessionResponseAccount: Codable {
    let registered: Bool?
    let key: String?
}

struct SessionResponseSession: Codable {
    let id: String?
    let expiration: String?
}

struct SessionResponse: Codable {
    let status: Int?
    let error: String?
    let account: SessionResponseAccount?
    let session: SessionResponseSession?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case error = "error"
        case account = "account"
        case session = "session"
    }
}

extension SessionResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
