//
//  FirebaseService.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 27.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore



class FirebaseService{
    
    var fireStore = Firestore.firestore()
    
    
    
    
    func createUser(with user : User , completion : @escaping (Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (auth,error) in
            if error != nil
            {
                completion(error!)
            }
            else
            {
                let userDic = ["email" : user.email , "username" : user.username] as! [String:Any]
                
                self.fireStore.collection("UserInfo").addDocument(data: userDic) { error in
                    if error != nil 
                    {
                        completion(error!)
                    }
                    else
                    {
                        completion(nil)
                    }
                }
            }
            
        }
        
    }
    
    func signInUser(with user : User , completion : @escaping (Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: user.email, password: user.password) { result, error in
            if error != nil {
                completion(error)
            }
            else {
                completion(nil)
            }
        }
        
    }
}
