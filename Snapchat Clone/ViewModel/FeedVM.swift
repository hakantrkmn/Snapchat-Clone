//
//  FeedVM.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 27.12.2023.
//

import Foundation
import UIKit


class FeedVM {
    
    var service = FirebaseService()
    
    func getUserInfo(view : UIViewController){
        service.getUserInfo { error in
            if error != nil {
                view.createAlert(title: "Error", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func getSnaps(completion : @escaping (Error?,[Snap]?) -> Void){
        service.getSnaps { error, snaps in
            if error != nil {
                completion(error,nil)

            }else
            {
                completion(nil,snaps)

            }
        }
    }
}
