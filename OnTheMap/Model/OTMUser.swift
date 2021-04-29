//
//  OTMUser.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 28/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation
import UIKit

class OTMUser {
    
    static let key = ""
    
    struct Auth {
        static var account = 0
        // static var requestToken = ""
        static var id = ""
    }
    
    enum Enpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case login
        
        var stringValue: String {
            switch self {
            case .createSessionId: return Enpoints.base + "/session\(Auth.id)"
            // case .login: return Enpoints.base + "/users/\(OTMUser.key)"
            case .login: return Enpoints.base + "/users/\(Auth.id)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //post
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print("login")
        let request = URLRequest(url: Enpoints.login.url)
        print(Enpoints.login.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = 5..<data!.count //Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        //class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print("createSessionId")
        //   var request = URLRequest(url: Enpoints.createSessionId.url)
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        //   print(Enpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        
        //        let body = PostSession(expiration: OTMUser)
        //        request.httpBody = try! JSONEncoder().encode(body)
        //
        // let session = URLSession.shared
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count //Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}

