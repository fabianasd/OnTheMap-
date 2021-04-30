//
//  RequestTokenResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 28/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    
    let registered: String
    let key: String

    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
}
