//
//  RequestTokenResponse.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 28/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    
    let registred: String
    let key: String

//havia muitas propriedades, bem como uma enumeracao de chaves de codificacao para cada uma
    enum CodingKeys: String, CodingKey {
        case registred
        case key
    }
}
