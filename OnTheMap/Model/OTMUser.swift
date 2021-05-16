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
        case deleteSession
        
        var stringValue: String {
            switch self {
            case .getUser: return Enpoints.base + "/users/\(OTMUser.key)" //recuperar algumas informacoes antes de postar no Parse
            case .createSessionId: return Enpoints.base + "/session" //autenticar sessao
            case .getStudentLocation: return Enpoints.base + "/StudentLocation?order=-updateAt" //obter a localizacao de varios alunos ao mesmo tempo
            case .postStudentLocation: return Enpoints.base + "/StudentLocation" //criar um novo local de aluno
            case .putStudentLocation: return Enpoints.base + "/StudentLocation/\(OTMUser.Auth.id)" //atualizar a localização de um aluno existente
            case .deleteSession: return Enpoints.base + "/session" //logout
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
    //post - 11
    class func getUser(completion: @escaping (GetUserResponse?, Error?) -> Void) {
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
    }
    
    //post - 9
    class func createSessionId(username: String, password: String, completion: @escaping (SessionResponse?, Error?) -> Void) {
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
                    completion(sessionResponse, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //get - 5
    class func getStudentLocation(completion: @escaping ([Map], Bool, Error?) -> Void) {
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
    
    //post - 6
    class func postStudentLocation(completion: @escaping (StudentResponse?, Error?) -> Void) {
        var request = URLRequest(url: Enpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody =
            ("{" +
                "\"uniqueKey\": \"1234\"," +
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
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            print(String(data: data!, encoding: .utf8)!)
            do {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                print(String(data: newData!, encoding: .utf8)!)
                
                let decoder = JSONDecoder()
                let studentResponse = try decoder.decode(StudentResponse.self, from: data!)
                DispatchQueue.main.async {
                    completion(studentResponse, nil)
                }
            }
            catch {
                print(error)
                //... falhar
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //put - 7
    class func putStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        //code
    }
    
    //delete - 10
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Enpoints.deleteSession.url)
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
                    completion()
                }
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}

