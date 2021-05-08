//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 04/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
