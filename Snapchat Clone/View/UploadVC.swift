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
class UploadVC: UIViewController {
    
    
    let vm = UploadVM()
    
    var uploadImageView : UIImageView = {
       var view = UIImageView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 10
        view.image = UIImage(named: "netflix")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    var uploadButton : UIButton = {
        var config = UIButton.Configuration.tinted()
        config.image = UIImage(systemName: "square.and.arrow.up")
        config.attributedTitle = AttributedString("Upload")
        config.imagePadding = 2
    
        var button = UIButton(configuration: config)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .systemBackground
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        
        uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func uploadTapped(){
        
        uploadButton.setTitle("yükleniyor", for: .normal)
        vm.uploadImage(with: uploadImageView.image!) { error in
            if error != nil{
                self.createAlert(title: "Error", message: error?.localizedDescription ?? "")
            }
            else
            {
                self.uploadButton.setTitle("yüklendi", for: .normal)
                self.tabBarController?.selectedIndex = 0
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
        uploadImageView.top(to: view.safeAreaLayoutGuide, offset: 20)
        uploadImageView.height(view.frame.height / 3)
        uploadImageView.width(to: view , offset: -20)
        uploadButton.topToBottom(of: uploadImageView,offset: 40)
        uploadButton.centerX(to: uploadImageView)
        uploadButton.width(view.frame.width / 2)
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)

    }

}

extension UploadVC : PHPickerViewControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        vm.getSelectedImage(results: results) { error, image in
            if error != nil {
                self.createAlert(title: "Error", message: error?.localizedDescription ?? "")
            }
            else {
                
                DispatchQueue.main.async{
                    self.uploadImageView.image = image

                }
            }
        }
       
    }
}
