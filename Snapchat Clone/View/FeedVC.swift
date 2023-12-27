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

    
    let fireStoreDatabase = Firestore.firestore()
    
    var feedTableView : UITableView = {
       var tableView = UITableView()
        tableView.register(FeedTVCell.self, forCellReuseIdentifier: FeedTVCell.identifier)
        return tableView
    }()
    
    var snapArray = [Snap]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        self.title = "feed"
        view.backgroundColor = .systemBackground
        feedTableView.delegate = self
        feedTableView.dataSource = self
        getUserInfo()

        getSnapsFromFirebase()
        //view.addSubview(tabbar.view)
        // Do any additional setup after loading the view.
    }
    
    func getUserInfo(){
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                print(snapshot?.count)
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String
                        {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username

                        }
                    }
                }
            }
        }
    }

    func setupUI(){
        view.addSubview(feedTableView)
        
        
        feedTableView.edgesToSuperview()
    }
    
    
    func getSnapsFromFirebase(){
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll()
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        if let username = document.get("snapOwner") as? String{
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if difference >= 24 {
                                            //self.fireStoreDatabase.collection("Snaps").document(documentID).delete()
                                        }
                                    }
                                    
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                }
                            }
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.feedTableView.reloadData()

                    }
                }
            }
        }
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
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = SnapVC()
        vc.snap = snapArray[indexPath.row]
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
    
}
