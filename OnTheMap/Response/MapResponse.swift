//
//  MapResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 02/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct MapResponse: Codable {
    let statusCode: Int?
    let statusMessage: String?
    let results: [Map]
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case results = "results"
    }
}

extension MapResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}

