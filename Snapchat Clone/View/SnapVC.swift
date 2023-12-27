//
//  SnapVC.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 23.12.2023.
//

import UIKit

class SnapVC: UIViewController {

    
    var pageControl : UIPageControl = {
        var page = UIPageControl()
        
        page.currentPageIndicatorTintColor = .lightGray
        page.pageIndicatorTintColor = .black
        
        return page
    }()

    var snapCollectionView : UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SnapCVCell.self, forCellWithReuseIdentifier: SnapCVCell.identifier)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var snap : Snap?
    var timeLeftLabel : UILabel = {
        var label = UILabel()
        
        label.text = " deneme "
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        snapCollectionView.delegate = self
        snapCollectionView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    
    func setupUI(){
        
        view.addSubview(timeLeftLabel)
        view.addSubview(snapCollectionView)
        view.addSubview(pageControl)
        
        timeLeftLabel.topToSuperview(offset: 100)
        timeLeftLabel.width(to: view,offset: -40)
        timeLeftLabel.centerXToSuperview()
        
        
        snapCollectionView.topToBottom(of: timeLeftLabel)
        snapCollectionView.centerX(to: timeLeftLabel)
        snapCollectionView.bottom(to: view , offset: -40)
        snapCollectionView.width(to: view)
        pageControl.bottom(to: view)
        pageControl.topToBottom(of: snapCollectionView)
        pageControl.centerX(to: view)
        pageControl.width(to: view , offset: -100)
        view.bringSubviewToFront(pageControl)
        
    }


}

extension SnapVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        pageControl.numberOfPages = snap!.imageUrlArray.count
        return snap!.imageUrlArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapCVCell.identifier, for: indexPath) as? SnapCVCell{
            print(indexPath.section)

            cell.configure(url: snap!.imageUrlArray[indexPath.section])
            return cell

        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width    , height: snapCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section

    }
}
