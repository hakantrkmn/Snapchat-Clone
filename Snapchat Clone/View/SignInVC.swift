//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 22.12.2023.
//

import UIKit
import TinyConstraints
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

class SignInVC: UIViewController {
    
    var appNameLabel : UILabel = {
        var label = UILabel()
        label.text = "SnapChat"
        return label
    }()
    
    var emailTextField : UITextField = {
        var field = UITextField()
        field.placeholder = "email"
        field.borderStyle = .roundedRect
        field.tintColor = .systemPink
        
        return field
    }()
    var usernameTextField : UITextField = {
        var field = UITextField()
        field.placeholder = "username"
        field.borderStyle = .roundedRect
        field.tintColor = .systemPink
        
        return field
    }()
    
    var passwordTextField : UITextField = {
        var field = UITextField()
        field.placeholder = "password"
        field.borderStyle = .line
        field.tintColor = .systemPink
        
        return field
    }()
    
    
    var signInButton : UIButton = {
        var button = UIButton()
        
        button.setTitle("Signin", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    
    var signUpButton : UIButton = {
        var button = UIButton()
        
        button.setTitle("signUp", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "sa"
        self.tabBarController?.tabBar.isHidden = true
        
        print("lknsdfk")
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    
    
    
    func setupUI(){
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints   = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(appNameLabel)
        view.addSubview(emailTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        appNameLabel.center(in: view, offset: CGPoint(x: 0, y: -view.frame.height/4))
        emailTextField.topToBottom(of: appNameLabel , offset: 10)
        emailTextField.centerX(to: appNameLabel)
        emailTextField.width(view.frame.width / 3 )
        
        
        usernameTextField.topToBottom(of: emailTextField , offset: 10)
        usernameTextField.centerX(to: emailTextField)
        usernameTextField.width(view.frame.width / 3 )
        
        
        passwordTextField.topToBottom(of: usernameTextField , offset: 10)
        passwordTextField.centerX(to: usernameTextField)
        passwordTextField.width(view.frame.width / 3 )
        
        signInButton.topToBottom(of: passwordTextField)
        signInButton.centerX(to: passwordTextField,offset: -view.frame.width / 6 )
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        
        signUpButton.topToBottom(of: passwordTextField)
        signUpButton.centerX(to: passwordTextField,offset: view.frame.width / 6 )
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    
    @objc func signUpTapped(){
        if usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){(auth,error) in
                if error != nil {
                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                }
                else
                {
                    let fireStore = Firestore.firestore()
                    let userDic = ["email" : self.emailTextField.text , "username" : self.usernameTextField.text] as! [String:Any]
                    fireStore.collection("UserInfo").addDocument(data: userDic) { error in
                        if error != nil {
                            print(error?.localizedDescription)
                        }
                    }
                    
                    let vc = TabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                
            }
        }else{
            self.makeAlert(title: "error", message: "sıkıtnı var")
        }
    }
    
    
    @objc func signInTapped(){
        
        if usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                }
                else {
                    let vc = TabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
            
            
        }
        else {
            self.makeAlert(title: "error", message: "sıkıtnı var")
            
        }
    }
    
    
    
    func makeAlert(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

