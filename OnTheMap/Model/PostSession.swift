//
//  PostSession.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 29/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//
import Foundation

struct PostSession: Codable {
        let expiration: String
        let id: String

        enum CodingKeys: String, CodingKey {
            case expiration
            case id
        }
}