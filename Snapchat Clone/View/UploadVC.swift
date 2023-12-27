//
//  UploadVC.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 23.12.2023.
//

import UIKit
import TinyConstraints
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
class UploadVC: UIViewController, PHPickerViewControllerDelegate {
    
    
    var itemProviders = [NSItemProvider]()
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(UserSingleton.sharedUserInfo.username)
        self.itemProviders = results.map(\.itemProvider)
        let item =  itemProviders[0]
        if ((item.canLoadObject(ofClass: UIImage.self)) != nil)
        {
            
            item.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.uploadImageView.image = image
                    }
                    else {
                        print(error?.localizedDescription)
                    }
                }
            })
        }
    }
    

    var uploadImageView : UIImageView = {
       var view = UIImageView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 10
        view.image = UIImage(named: "netflix")
        return view
    }()
    
    
    var uploadButton : UIButton = {
        var button = UIButton()
        button.setTitle("upload", for: .normal)
        button.setTitleColor(.black, for: .normal
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .systemBackground
        
        uploadImageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        
        uploadImageView.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func uploadTapped(){
        
        print(UserSingleton.sharedUserInfo.username)
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
         
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5)
        {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data) { (metadata,error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else {
                    imageReference.downloadURL{ (url,error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    print(error?.localizedDescription)
                                }
                                else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents{
                                            let documentid = document.documentID
                                            
                                            if var imageURLArray = document.get("imageUrlArray") as? [String] {
                                                imageURLArray.append(imageURL!)
                                                
                                                let additionalDic = ["imageUrlArray" : imageURLArray]
                                                
                                                fireStore.collection("Snaps").document(documentid).setData(additionalDic, merge: true) { error in
                                                    if error != nil {
                                                        print(error)
                                                        self.tabBarController?.selectedIndex = 0
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        
                                        let snapDic = ["imageUrlArray" : [imageURL!] , "snapOwner" : UserSingleton.sharedUserInfo.username, "date" : FieldValue.serverTimestamp()] as [String:Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDic) { error in
                                            if error != nil {
                                                print(error)
                                            }
                                            else {
                                                self.tabBarController?.selectedIndex = 0
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
    @objc func choosePicture(){
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration )
        picker.delegate = self
        
        present(picker, animated: true)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI(){
        
        
        view.addSubview(uploadImageView)
        view.addSubview(uploadButton)
        
        
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        
        uploadImageView.centerX(to: view)
        uploadImageView.top(to: view, offset: 100)
        uploadImageView.height(view.frame.height / 3)
        uploadImageView.width(to: view , offset: -20)
        uploadButton.topToBottom(of: uploadImageView,offset: 40)
        uploadButton.centerX(to: uploadImageView)
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)

    }

}
