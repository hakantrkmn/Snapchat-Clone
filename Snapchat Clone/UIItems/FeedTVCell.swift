//
//  FeedTVCell.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 25.12.2023.
//

import UIKit
import SDWebImage
class FeedTVCell: UITableViewCell {
    
    static let identifier = "FeedTVCell"
    
    
    var usernameLabel : UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        return label
    }()
    
    
    var snapView : UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "test")
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        self.selectionStyle = .none
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public func setupUI(){
        
        self.contentView.addSubview(snapView)
        self.contentView.addSubview(usernameLabel)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        snapView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.top(to: self.contentView , offset: 10)
        usernameLabel.centerX(to: self.contentView)
        
        snapView.topToBottom(of: usernameLabel , offset: 10)
        snapView.centerX(to: usernameLabel)
        snapView.bottom(to: self.contentView)
    }
    
    public func configure(with snap : Snap){
        snapView.sd_setImage(with: URL(string: snap.imageUrlArray.last ?? ""))
        usernameLabel.text = snap.username
    }
    
}
