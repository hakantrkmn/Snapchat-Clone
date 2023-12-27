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
    
    
    
    func createUser(with email : String , password : String , username : String) throws{
        do{
            Auth.auth().createUser(withEmail: email, password: password){ (auth,error) in
                if error != nil {
                    Utility.makeAlert(title: "Error", message: error?.localizedDescription ?? "")
                }
                else
                {
                    let fireStore = Firestore.firestore()
                    let userDic = ["email" : email , "username" : username] as! [String:Any]
                    fireStore.collection("UserInfo").addDocument(data: userDic) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                    }
                    
    //                let vc = TabBarController()
    //                vc.modalPresentationStyle = .fullScreen
    //                self.present(vc, animated: true)
                }
                
            }
        }catch{
            
        }
        
    }
}
