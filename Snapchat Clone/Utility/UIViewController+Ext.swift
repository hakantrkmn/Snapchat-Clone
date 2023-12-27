//
//  UIViewController+Ext.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 27.12.2023.
//

import Foundation
import UIKit


extension UIViewController{
    
    
    func createAlert(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
