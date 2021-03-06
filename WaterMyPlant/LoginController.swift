//
//  LoginController.swift
//  WaterMyPlant
//
//  Created by Lambda_School_Loaner_201 on 2/29/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import Foundation


class LoginController {
    
    struct LoginResponse: Codable {
        
        var message: String
        var token: String
        var user: User
    }
    
    static var shared = LoginController()
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://webpt9-water-my-plants.herokuapp.com/api")!
    var token: Token?
    var user: User?
    
    func login(with loginData: LoginRequest, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("/auth/login")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(loginData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                let user = loginResponse.user
                self.token = Token(id: user.id, token: loginResponse.token)
                self.user = user
            } catch {
                print("Error decoding Token: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
