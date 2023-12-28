//
//  FeedVC.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 23.12.2023.
//

import UIKit
import TinyConstraints
import FirebaseFirestore
import FirebaseAuth


class FeedVC: UIViewController {

    
    let vm = FeedVM()
    
    var feedTableView : UITableView = {
       var tableView = UITableView()
        tableView.register(FeedTVCell.self, forCellReuseIdentifier: FeedTVCell.identifier)
        return tableView
    }()
    
    public var nicknameLabel : UILabel = {
       var label = UILabel()
        return label
    }()
    
    var snapArray = [Snap]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        self.title = "Feed"
        view.backgroundColor = .systemBackground
        feedTableView.delegate = self
        feedTableView.dataSource = self
        


    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDatabase()

    }
    func setDatabase() {
        vm.getSnaps { error, snaps in
            if error != nil {
                self.createAlert(title: "Error", message: error?.localizedDescription ?? "")
            }
            else {
                self.snapArray = snaps!
                DispatchQueue.main.async {
                    self.feedTableView.reloadData()

                }
            }
        }
        
        vm.getUserInfo { error in
            if error != nil {
                self.createAlert(title: "Error", message: error?.localizedDescription ?? "")
            }
            else {
                print(UserSingleton.sharedUserInfo.username)
                self.nicknameLabel.text = UserSingleton.sharedUserInfo.username

            }
        }

    }
    

    func setupUI(){
        view.addSubview(feedTableView)
        self.navigationController?.navigationBar.addSubview(nicknameLabel)
     
        
        feedTableView.edgesToSuperview()
        
        nicknameLabel.trailingToSuperview()
        nicknameLabel.centerY(to: self.navigationController!.navigationBar)
    }
    
    
   

}

extension FeedVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTVCell.identifier, for: indexPath) as! FeedTVCell
        cell.configure(with: snapArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.safeAreaLayoutGuide.layoutFrame.height / 1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = SnapVC()
        vc.snap = snapArray[indexPath.row]
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
}
