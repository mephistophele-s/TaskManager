//
//  LoginUser.swift
//  TaskManager
//
//  Created by Anastasia on 13.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

class LoginUser: RequestType {
   
    typealias ResponseType = User
  
    let data: RequestData
    let path = "/auth"
    let method: HTTPMethod = .post
    
    let headers = ["Content-Type": "application/json"]
    
    init(email: String, password: String) {
        let params = ["email": email, "password": password]
        data = RequestData(path: path, method: method, params: params, headers: headers)
    }
}
