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
        
        case login
        case createSessionId
        case getStudentLocation
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .login: return Enpoints.base + "/users/\(OTMUser.key)"
            case .createSessionId: return Enpoints.base + "/session"
            case .getStudentLocation: return Enpoints.base + "/StudentLocation?order=-updateAt"
            case .postStudentLocation: return Enpoints.base + "/StudentLocation"
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
    
    //post
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Enpoints.createSessionId.url)
        //  var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
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
    
    //get
    class func getStudentLocation(completion: @escaping ([Map], Bool, Error?) -> Void) {
        print("studentLocation")
        var request = URLRequest(url: Enpoints.getStudentLocation.url)
        print(Enpoints.getStudentLocation.url)
        // let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error  in
            if error != nil { // Handle error...
                DispatchQueue.main.async {
                    completion([], false, error)
                }
            }
            print(String(data: data!, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(MapResponse.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject.results, true, nil)
                }
            }
            catch {
                print(error)
                //... falhar
                DispatchQueue.main.async {
                    completion([], false, error)
                }
            }
            
        }
        task.resume()
    }
    
 //post
    class func postStudentLocation(createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaString: String?, mediaURL: String, objectId: String, uniqueKey: String, updatedAt: String, completion: @escaping (Bool, Error?) -> Void) {
        // var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        var request = URLRequest(url: Enpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}

