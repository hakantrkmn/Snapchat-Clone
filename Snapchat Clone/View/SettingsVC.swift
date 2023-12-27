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

    let logoutButton : UIButton = {
        let button  = UIButton()
        
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("sa", for: .highlighted)
        button.setTitleColor(.systemPink, for: .highlighted)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = CGFloat(1)
        button.layer.cornerRadius = CGFloat(8)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc func logoutButtonTapped(){
        
        do {
            try Auth.auth().signOut()
            let vc = SignInVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        }catch{
            
        }
        
        
    }
    

    func setupUI(){
        view.addSubview(logoutButton)
        
        logoutButton.center(in: view )
        logoutButton.widthToSuperview(offset: -view.frame.width / 2)
        
    }
    

}
