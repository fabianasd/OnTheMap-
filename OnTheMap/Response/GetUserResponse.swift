//
//  GetUserResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 08/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct GetUserResponse: Codable {
    let status: Int?
    let error: String?
    let lastName: String?
    let mailingAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case error = "error"
        case lastName = "last_name"
        case mailingAddress = "mailing_address"
    }
}

extension GetUserResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
