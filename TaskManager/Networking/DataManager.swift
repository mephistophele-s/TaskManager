//
//  DataManager.swift
//  TaskManager
//
//  Created by Anastasia on 13.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

enum RequestError: Swift.Error {
    case invalidURL
    case noData
    case notAuthorized
}

class DataManager {
    
    public static let instance = DataManager()
    private init() {}
    
    private let baseURL = "https://testapi.doitserver.in.ua/api"
    
    var currentUser: User?
    
    public func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: baseURL + request.path) else {
            onError(RequestError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        do {
            if let params = request.params {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            onError(error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            guard let _data = data else {
                onError(RequestError.noData)
                return
            }
            
        
            onSuccess(_data)
        }.resume()
    }
}
