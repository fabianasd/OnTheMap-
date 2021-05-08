//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 04/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct TMDBResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension TMDBResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
