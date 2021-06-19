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
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getUser
        case createSessionId
        case getStudentLocation
        case postStudentLocation
        case putStudentLocation
        case deleteSession
        
        var stringValue: String {
            switch self {
            case .getUser: return Endpoints.base + "/users/\(OTMUser.key)" //recuperar algumas informacoes antes de postar no Parse
            case .createSessionId: return Endpoints.base + "/session" //autenticar sessao
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?order=-updateAt" //obter a localizacao de varios alunos ao mesmo tempo - decrescente
            case .postStudentLocation: return Endpoints.base + "/StudentLocation" //criar um novo local de aluno
            case .putStudentLocation: return Endpoints.base + "/StudentLocation/\(OTMUser.Auth.objectId)" //atualizar a localização de um aluno existente
            case .deleteSession: return Endpoints.base + "/session" //logout
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error  in
            guard let data = data else {
                //acontece se houver um erro com a solicitação
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    //se a analise JSON for bem-sucedida ou...
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    //... falhar
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, SessionResponse: Decodable>(url: URL, sessionResponse: SessionResponse.Type, body: RequestType, completion: @escaping(SessionResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                //acontece se houver um erro com a solicitação
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(SessionResponse.self, from: data)
                DispatchQueue.main.async {//recarregamos os dados no thread principal usando assincrono.
                    //se a analise JSON for bem-sucedida ou...
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    
                    let decoder = JSONDecoder()
                    let sessionResponse = try decoder.decode(SessionResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(sessionResponse, nil)
                    }
                } catch {
                    //... falhar
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //get - 11
    class func getUser(completion: @escaping (GetUserResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUser.url, response: GetUserResponse.self) { response, error in
            if let response = response {
                completion(response, error)
            } else {
                completion(nil, error)
            }
        }
        
        //
        //        let request = URLRequest(url: Enpoints.getUser.url)
        //        print(Enpoints.getUser.url)
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request) { data, response, error in
        //            if error != nil {
        //                completion(nil, error)
        //            }
        //            let range = 5..<data!.count
        //            let newData = data?.subdata(in: range)
        //            print(String(data: data!, encoding: .utf8)!)
        //            do {
        //                let range = 5..<data!.count
        //                let newData = data?.subdata(in: range)
        //
        //                let decoder = JSONDecoder()
        //                let getUserResponse = try decoder.decode(GetUserResponse.self, from: newData!)
        //                UserModel.user = getUserResponse
        //                DispatchQueue.main.async {
        //                    completion(getUserResponse, error)
        //                }
        //            }
        //            catch {
        //                DispatchQueue.main.async {
        //                    completion(nil, error)
        //                }
        //            }
        //            completion(nil, error)
        //        }
        //        task.resume()
    }
    
    //post - 9
    class func createSessionId(username: String, password: String, completion: @escaping (SessionResponse?, Error?) -> Void) {
        let createSessionUdacity = CreateSessionUdacityRequest(username: username, password: password)
        let body = CreateSessionRequest(udacity: createSessionUdacity)
        
        taskForPOSTRequest(url: Endpoints.createSessionId.url, sessionResponse: SessionResponse.self, body: body) { response, error in
            if let response = response {
                completion(response, error)
            } else {
                completion(nil, error)
            }
        }
        // }
        //        var request = URLRequest(url: Endpoints.createSessionId.url)
        //
        //        request.httpMethod = "POST"
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //
        //        request.httpBody =
        //            ("{" +
        //                "\"udacity\": " +
        //                "{" +
        //                "\"username\":\"\(username)\"," +
        //                "\"password\": \"\(password)\"" +
        //                "}" +
        //                "}").data(using: .utf8)
        //
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request) { data, response, error in
        //
        //            if error != nil {
        //                DispatchQueue.main.async {
        //                    completion(nil, error)
        //                }
        //            }
        //
        //            do {
        //                let range = 5..<data!.count
        //                let newData = data?.subdata(in: range)
        //
        //                let decoder = JSONDecoder()
        //                let sessionResponse = try decoder.decode(SessionResponse.self, from: newData!)
        //                DispatchQueue.main.async {
        //                    completion(sessionResponse, nil)
        //                }
        //            } catch {
        //                DispatchQueue.main.async {
        //                    completion(nil, error)
        //                }
        //            }
        //        }
        //        task.resume()
    }
    
    //get - 5
    class func getStudentLocation(completion: @escaping ([Map], Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, response: MapResponse.self) { response, error in
            if let response = response {
                completion(response.results, true, nil)
            } else {
                completion([], false, error)
            }
        }
        
        //        var request = URLRequest(url: Endpoints.getStudentLocation.url)
        //        print(Endpoints.getStudentLocation.url)
        //        // let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request) { data, response, error  in
        //            if error != nil { // Handle error...
        //                DispatchQueue.main.async {
        //                    completion([], false, error)
        //                }
        //            }
        //            print(String(data: data!, encoding: .utf8)!)
        //
        //            let decoder = JSONDecoder()
        //
        //            do {
        //                let responseObject = try decoder.decode(MapResponse.self, from: data!)
        //                DispatchQueue.main.async {
        //                    completion(responseObject.results, true, nil)
        //                }
        //            }
        //            catch {
        //                print(error)
        //                //... falhar
        //                DispatchQueue.main.async {
        //                    completion([], false, error)
        //                }
        //            }
        //
        //        }
        //        task.resume()
    }
    
    //post - 6
    class func postStudentLocation(uniqueKey: Int, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (StudentResponse?, Error?) -> Void) {
        let body = StudentRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, sessionResponse: StudentResponse.self, body: body) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
//        var request = URLRequest(url: Endpoints.postStudentLocation.url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody =
//            ("{" +
//                "\"uniqueKey\": \"1234\"," +
//                "\"firstName\": \"AAAAAAFernanda\"," +
//                "\"lastName\": \"Brasil\"," +
//                "\"mapString\": \"Rio de Janeiro, RJ\"," +
//                "\"mediaURL\": \"https://udacity.com\"," +
//                "\"latitude\": -22.96466749110056," +
//                "\"longitude\": -43.17709978734727" +
//                "}").data(using: .utf8)
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//            }
//            print(String(data: data!, encoding: .utf8)!)
//            do {
//                let range = 5..<data!.count
//                let newData = data?.subdata(in: range)
//                print(String(data: newData!, encoding: .utf8)!)
//
//                let decoder = JSONDecoder()
//                let studentResponse = try decoder.decode(StudentResponse.self, from: data!)
//                DispatchQueue.main.async {
//                    completion(studentResponse, nil)
//                }
//            }
//            catch {
//                print(error)
//                //... falhar
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//            }
//        }
//        task.resume()
//    }
    
    //put - 7
    class func putStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        //  let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8"
        var request = URLRequest(url: Endpoints.putStudentLocation.url)
        //   let url = URL(string: urlString)
        //   var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody =
            ("{" +
                "\"uniqueKey\": \"12344321\"," +
                "\"firstName\": \"AAAAAAFernanda\"," +
                "\"lastName\": \"Brasil\"," +
                "\"mapString\": \"Rio de Janeiro, RJ\"," +
                "\"mediaURL\": \"https://udacity.com\"," +
                "\"latitude\": -22.96466749110056," +
                "\"longitude\": -43.17709978734727" +
                "}").data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    //delete - 10
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
            do {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                
                let decoder = JSONDecoder()
                let sessionResponse = try decoder.decode(logoutResponse.self, from: newData!)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
}

