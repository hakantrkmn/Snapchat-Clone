//
//  SnapCVCell.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 26.12.2023.
//

import UIKit

class SnapCVCell: UICollectionViewCell {
    static let identifier = "SnapCVCell"
    
    var snapView : UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "test")
        view.clipsToBounds = true
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        // initialize what is needed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setupUI(){
        
        self.contentView.addSubview(snapView)
        
        
        
        snapView.translatesAutoresizingMaskIntoConstraints = false
        
        
        snapView.edgesToSuperview()
    }
    public func configure(url : String){
        snapView.sd_setImage(with: URL(string: url))
    }
    
}
