//
//  AuthenticationVM.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 27.12.2023.
//

import Foundation


struct AuthenticationVM {
    
    var service  = FirebaseService()
    
    
    func createNewUser(with user : User,completion : @escaping (Error?) -> ()){
        service.createUser(with: user) { error in
            if error != nil 
            {
                completion(error)
            }
            else
            {
                completion(nil)
            }
        }
    }
    func signIn(with user : User,completion : @escaping (Error?) -> ()){
        service.signInUser(with: user) { error in
            if error != nil {
                completion(error)
            }else {
                completion(nil)
            }
        }
    }
}
