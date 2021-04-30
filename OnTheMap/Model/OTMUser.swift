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
        static var id = ""
    }
    
    enum Enpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case login
        
        var stringValue: String {
            switch self {
            case .createSessionId: return Enpoints.base + "/session"
            case .login: return Enpoints.base + "/users/\(OTMUser.key)"
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
                completion(false, error)
            }
            let range = 5..<data!.count //Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print("createSessionId")
        //   var request = URLRequest(url: Enpoints.createSessionId.url)
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody =
            ("{" +
                "\"udacity\": " +
                "{" +
                    "\"username\":\"\(username)\"," +
                    "\"password\": \"\(password)\"" +
                "}" +
             "}").data(using: .utf8)
        
        //request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            let range = 5..<data!.count //Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async {
                completion((data != nil), error)
            }
        }
        task.resume()
    }
}

