//
//  User.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 27.12.2023.
//

import Foundation


class User {
    var username : String = ""
    var email : String = ""
    var password : String = ""
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}
