//
//  Map.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 02/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation
struct Map: Codable, Equatable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaString: String?
    var mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    
    var releaseYear: String {
        return String(createdAt.prefix(4))
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
}
