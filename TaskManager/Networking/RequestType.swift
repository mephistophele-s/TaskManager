//
//  RequestType.swift
//  TaskManager
//
//  Created by Anastasia on 13.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

protocol RequestType {
  
    associatedtype ResponseType: Codable
    var data: RequestData { get }
}

extension RequestType {
    
    func execute (
        manager: DataManager = DataManager.instance,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        manager.dispatch(
            request: self.data,
            onSuccess: { (responseData: Data) in
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                    

                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        onError(error)
                    }
                }
            },
            onError: { (error: Error) in
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        )
    }
}


