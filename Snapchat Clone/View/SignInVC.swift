//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 22.12.2023.
//

import UIKit
import TinyConstraints

class SignInVC: UIViewController {
    
    
    var vm = AuthenticationVM()
    
    var appNameLabel : UILabel = {
        var label = UILabel()
        label.text = "Snapchat"
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .systemYellow
        return label
    }()
    
    var emailTextField : UITextField = {
        var field = UITextField()
        field.placeholder = "Email"
        field.borderStyle = .roundedRect
        field.tintColor = .systemPink
        
        return field
    }()
    var usernameTextField : UITextField = {
        var field = UITextField()
        field.placeholder = "Username"
        field.borderStyle = .roundedRect
        field.tintColor = .systemPink
        
        return field
    }()
    
    var passwordTextField : UITextField = {
        var field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()
    
    var showHideButton : UIButton = {
        var field = UIButton()
        field.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        return field
    }()
    
    
    var signInButton : UIButton = {
        
        var button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        return button
    }()
    
    
    var signUpButton : UIButton = {
        var button = UIButton()
        
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemGreen
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    
    
    
    func setupUI()
    {
        
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints      = false
        emailTextField.translatesAutoresizingMaskIntoConstraints    = false
        signInButton.translatesAutoresizingMaskIntoConstraints      = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.translatesAutoresizingMaskIntoConstraints    = false
        
        
        view.addSubview(appNameLabel)
        view.addSubview(emailTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        passwordTextField.addSubview(showHideButton)
        
        appNameLabel.center(in: view, offset: CGPoint(x: 0, y: -view.frame.height/4))
        
        emailTextField.topToBottom(of: appNameLabel , offset: 50)
        emailTextField.centerX(to: appNameLabel)
        emailTextField.width(view.frame.width / 1.5 )
        
        
        usernameTextField.topToBottom(of: emailTextField , offset: 10)
        usernameTextField.centerX(to: emailTextField)
        usernameTextField.width(to: emailTextField)
        
        
        passwordTextField.topToBottom(of: usernameTextField , offset: 10)
        passwordTextField.centerX(to: usernameTextField)
        passwordTextField.width(to: emailTextField)
        
        
        showHideButton.trailing(to: passwordTextField)
        showHideButton.height(to: passwordTextField)
        showHideButton.width(40)
        passwordTextField.bringSubviewToFront(showHideButton)
        
        signInButton.topToBottom(of: passwordTextField ,offset: 20)
        signInButton.centerX(to: passwordTextField,offset: -view.frame.width / 6 )
        signInButton.width((view.frame.width / 4) )
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        
        signUpButton.topToBottom(of: passwordTextField,offset: 20)
        signUpButton.centerX(to: passwordTextField,offset: view.frame.width / 6 )
        signUpButton.width((view.frame.width / 4) )
        
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        
        showHideButton.addTarget(self, action: #selector(showHideTapped), for: .touchDown)
        showHideButton.addTarget(self, action: #selector(showHideTapped), for: .touchUpInside)
        
    }
    
    
    @objc func showHideTapped(){
        if passwordTextField.isSecureTextEntry{
            passwordTextField.isSecureTextEntry = false
            showHideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        else {
            passwordTextField.isSecureTextEntry = true
            showHideButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @objc func signUpTapped(){
        
        if usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != "" {
            
            let user = User(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
            
            vm.createNewUser(with: user) { error in
                if error != nil {
                    self.createAlert(title: "Error", message: error!.localizedDescription)
                }
                else {
                    let vc = TabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
            
            
        }else{
            self.createAlert(title: "Error", message: "Fields are empty")
        }
    }
    
    
    @objc func signInTapped(){
        
        if usernameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != "" {
            let user = User(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
            
            vm.signIn(with: user) { error in
                if error != nil {
                    self.createAlert(title: "Error", message: error!.localizedDescription)
                }
                else {
                    let vc = TabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
            
            
            
        }
        else {
            self.createAlert(title: "Error", message: "Fields are empty")
            
        }
    }
    
}

