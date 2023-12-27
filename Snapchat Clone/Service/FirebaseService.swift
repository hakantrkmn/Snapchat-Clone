//
//  FirebaseService.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 27.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class FirebaseService{
    
    var fireStore = Firestore.firestore()
    let storage = Storage.storage()
    

    
    
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
    
    
    func logOutUser(completion : @escaping (Error?) -> ()) {
        
        do {
            try Auth.auth().signOut()
            completion(nil)
            
        }catch{
            completion(error)

        }
        
        
    }
    
    func getUserInfo(completion : @escaping (Error?) -> ()) {

        fireStore.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { snapshot, error in
            if error != nil {

                completion(error)
            }
            else {
                
                if snapshot?.isEmpty == false && snapshot != nil {

                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String
                        {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                            completion(nil)
                        }
                    }
                }
            }
        }
        
    }
    
    func deleteSnap(id : String){
        fireStore.collection("Snaps").document(id).delete()
    }
    func getSnaps(completion : @escaping (Error?,[Snap]?) -> Void){
        var snapArray : [Snap] = []
        fireStore.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                completion(error,nil)
            }
            else {
                snapArray.removeAll()
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        if let username = document.get("snapOwner") as? String{
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {

                                    if let difference = Calendar.current.dateComponents([.minute], from: date.dateValue(), to: Date()).minute{
                                        if difference >= 1440 {
                                            //self.fireStoreDatabase.collection("Snaps").document(documentID).delete()
                                            self.deleteSnap(id: documentID)
                                        }
                                        else {
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeLeft: (1440-difference) / 60)
                                            snapArray.append(snap)
                                        }
                                    }

                                    
                                }
                            }
                            
                        }
                    }
                    completion(nil,snapArray)
                }
            }
        }
    }
    
    
    
    
    func uploadImage(with image : UIImage , to destination : String , completion : @escaping (Error?)-> ()){
        
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child(destination)
         
        if let data = image.jpegData(compressionQuality: 0.5)
        {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data) { (metadata,error) in
                if error != nil {
                    completion(error)
                }
                else {
                    imageReference.downloadURL{ (url,error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            
                            
                            self.fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    completion(error)
                                }
                                else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents{
                                            let documentid = document.documentID
                                            
                                            if var imageURLArray = document.get("imageUrlArray") as? [String] {
                                                imageURLArray.append(imageURL!)
                                                
                                                let additionalDic = ["imageUrlArray" : imageURLArray]
                                                
                                                self.fireStore.collection("Snaps").document(documentid).setData(additionalDic, merge: true) { error in
                                                    if error != nil {
                                                        completion(error)
                                                        //self.tabBarController?.selectedIndex = 0
                                                    }
                                                    else
                                                    {
                                                        completion(nil)

                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        
                                        let snapDic = ["imageUrlArray" : [imageURL!] , "snapOwner" : UserSingleton.sharedUserInfo.username, "date" : FieldValue.serverTimestamp()] as [String:Any]
                                        
                                        self.fireStore.collection("Snaps").addDocument(data: snapDic) { error in
                                            if error != nil {
                                                completion(error)
                                            }
                                            else {
                                                completion(nil)
                                                //self.tabBarController?.selectedIndex = 0
                                            }
                                        }
                                    }
                                }
                            }
                            
                         
                        }
                        
                    }
                }
            }
        }
    }
        
}
