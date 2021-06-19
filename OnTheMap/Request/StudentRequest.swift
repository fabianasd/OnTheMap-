//
//  StudentRequest.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 18/06/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct StudentRequest: Codable {
    let uniqueKey: Int
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
}
