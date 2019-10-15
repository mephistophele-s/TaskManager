//
//  User.swift
//  TaskManager
//
//  Created by Anastasia on 13.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(token, forKey: .token)
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      token = try container.decode(String.self, forKey: .token)
    }
}
