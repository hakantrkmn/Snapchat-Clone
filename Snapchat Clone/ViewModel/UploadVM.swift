//
//  UploadVM.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 27.12.2023.
//

import Foundation
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

class UploadVM {
    
    var itemProviders = [NSItemProvider]()
   var service = FirebaseService()

    
    func getSelectedImage(results: [PHPickerResult], completion : @escaping (Error?,UIImage?) -> ()){
        self.itemProviders = results.map(\.itemProvider)
        let item =  itemProviders.first!
        
        item.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                if let image = image as? UIImage {
                    completion(nil,image)
                }
                else {
                    completion(error,nil)
                }
            
        })
        
    }
    
    
   
    
    func uploadImage(with image : UIImage , completion : @escaping (Error?)-> ()){
        service.uploadImage(with: image,to: "media") { error in
            completion(error)
        }
    }
        
       
    
}
