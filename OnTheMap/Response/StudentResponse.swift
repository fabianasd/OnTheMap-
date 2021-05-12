//
//  PostStudent.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 11/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

class StudentResponse: Codable {
    let objectId: String
    let createdAt: String
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectId"
        case createdAt = "createdAt"
        case error = "error"
    }
}

extension StudentResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
