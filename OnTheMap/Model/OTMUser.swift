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
    
    static var key = ""
    
    struct Auth {
        static var account = 0
        static var id = ""
    }
    
    enum Enpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getUser
        case createSessionId
        case getStudentLocation
        case postStudentLocation
        case putStudentLocation
        
        var stringValue: String {
            switch self {
            case .getUser: return Enpoints.base + "/users/\(OTMUser.key)" //recuperar algumas informacoes antes de postar no Parse
            case .createSessionId: return Enpoints.base + "/session" //autenticar sessao
            case .getStudentLocation: return Enpoints.base + "/StudentLocation?order=-updateAt" //obter a localizacao de varios alunos ao mesmo tempo
            case .postStudentLocation: return Enpoints.base + "/StudentLocation"
            case .putStudentLocation: return Enpoints.base + "/StudentLocation/\(OTMUser.Auth.id)" //criar um novo aluno
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //@discardableResult silencia os avisos de retornos não utilizados
    //    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) -> URLSessionTask {
    //        let task = URLSession.shared.dataTask(with: url) { data, response, error  in
    //            guard let data = data else {
    //                //acontece se houver um erro com a solicitação
    //                DispatchQueue.main.async {
    //                    completion(nil, error)
    //                }
    //                return
    //            }
    //            let decoder = JSONDecoder()
    //            do {
    //                let responseObject = try decoder.decode(ResponseType.self, from: data)
    //                DispatchQueue.main.async {
    //                    //se a analise JSON for bem-sucedida ou...
    //                    completion(responseObject, nil)
    //                }
    //            } catch {
    //                do {
    //                    let errorResponse = try decoder.decode(OTMResponse.self, from: data)
    //                    DispatchQueue.main.async {
    //                        completion(nil, errorResponse)
    //                    }
    //                } catch {
    //                    //... falhar
    //                    DispatchQueue.main.async {
    //                        completion(nil, error)
    //                    }
    //                }
    //            }
    //        }
    //        task.resume()
    //        return task
    //    }
    //
    //    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?) -> Void) {
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.httpBody = try! JSONEncoder().encode(body)
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            guard let data = data else {
    //                //acontece se houver um erro com a solicitação
    //                DispatchQueue.main.async {
    //                    completion(nil, error)
    //                }
    //                return
    //            }
    //            let decoder = JSONDecoder()
    //            do {
    //                let responseObject = try decoder.decode(ResponseType.self, from: data)
    //                DispatchQueue.main.async {//recarregamos os dados no thread principal usando assincrono.
    //                    //se a analise JSON for bem-sucedida ou...
    //                    completion(responseObject, nil)
    //                }
    //            } catch {
    //                do {
    //                    let errorResponse = try decoder.decode(OTMResponse.self, from: data)
    //                    DispatchQueue.main.async {
    //                        completion(nil, errorResponse)
    //                    }
    //                } catch {
    //                    //... falhar
    //                    completion(nil, error)
    //                }
    //            }
    //        }
    //        task.resume()
    //    }
    //post
    class func getUser(completion: @escaping (GetUserResponse?, Error?) -> Void) {
        
        // Mock
        DispatchQueue.main.async {
            completion(GetUserResponse(status: nil, error: nil, lastName: "Petrovick", mailingAddress: "petrovickg@hotmail.com"), nil)
        }
        /*
        //Official implementation
        let request = URLRequest(url: Enpoints.getUser.url)
        print(Enpoints.getUser.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: data!, encoding: .utf8)!)
            do {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                
                let decoder = JSONDecoder()
                let getUserResponse = try decoder.decode(GetUserResponse.self, from: newData!)
                UserModel.user = getUserResponse
                DispatchQueue.main.async {
                    completion(getUserResponse, error)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            completion(nil, error)
        }
        task.resume()
        */
    }
    
    //post
    class func createSessionId(username: String, password: String, completion: @escaping (SessionResponse?, Error?) -> Void) {
        // Mock
        DispatchQueue.main.async {
            completion(SessionResponse(status: nil, error: nil, account: SessionResponseAccount(registered: true, key: "1234567890"), session: SessionResponseSession(id: "OutroId", expiration: "2021-05-09T12:49:00Z")), nil)
        }
        /*
        //Official implementation
        var request = URLRequest(url: Enpoints.createSessionId.url)
        
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
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            do {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                
                let decoder = JSONDecoder()
                let sessionResponse = try decoder.decode(SessionResponse.self, from: newData!)
                DispatchQueue.main.async {
                    completion(sessionResponse, error)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        */
    }
    
    //get
    class func getStudentLocation(completion: @escaping ([Map], Bool, Error?) -> Void) {
        DispatchQueue.main.async {
            completion([], false, nil)
        }
        /*
        //Official implementation
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
        */
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

