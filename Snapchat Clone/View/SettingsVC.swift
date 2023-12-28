//
//  SettingsVC.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 23.12.2023.
//

import UIKit
import TinyConstraints
import FirebaseAuth
class SettingsVC: UIViewController {

    
    var service =  FirebaseService()
    
    let logoutButton : UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        config.attributedTitle = AttributedString("Logout")
        
        
        let button  = UIButton(configuration: config)
        
       
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    @objc func logoutButtonTapped(){
        
        service.logOutUser { error in
            if error != nil {
                self.createAlert(title: "Error", message: error?.localizedDescription ?? "")
            }
            else{
                let vc = SignInVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            
        }
        
    }
    

    func setupUI(){
        view.addSubview(logoutButton)
        
        logoutButton.center(in: view )
        logoutButton.widthToSuperview(offset: -view.frame.width / 2)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

    }
    

}
