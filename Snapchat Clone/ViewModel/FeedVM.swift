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
    
    func getUserInfo(completion : @escaping (Error?) -> Void) {
        service.getUserInfo { error in
            completion(error)
            
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
