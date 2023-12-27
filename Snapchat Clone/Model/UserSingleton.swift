//
//  UserSingleton.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 24.12.2023.
//

import Foundation

class UserSingleton{
    
    static let sharedUserInfo = UserSingleton()
    
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
