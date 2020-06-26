//
//  PermissViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/20/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ProjectImagesViewController: BaseViewController {
    
   
    
    @IBOutlet weak var header: NavigationBar!
       @IBOutlet weak var collectionView: UICollectionView!
    var id = 0
    var permissions = [ImageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        collectionView.register(TransportViewCell.nib, forCellWithReuseIdentifier: TransportViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        setupHeader()
        getProjectCompletionImages()
        
    }
    
    func setupHeader() {
        header.title = "Album"

        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    func getProjectCompletionImages() {
        showLoading()
        APIClient.getProjectCompletionImages(id : id){ result in
            self.stopLoading()
            switch result {
            case .success(let articles):
                if(articles.data != nil) {
                    self.permissions = articles.data!
                }
                 
                self.getProjectImages()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getProjectImages() {
        showLoading()
        APIClient.getProjectImages(id : id){ result in
            self.stopLoading()
            switch result {
            case .success(let articles):
                
                if(articles.data != nil) {
                 
                    self.permissions.append(contentsOf: articles.data!)
                     self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupView(data:[ImageModel]) {
       
    }
    
}

extension ProjectImagesViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if permissions.count > 0 {
    
            numOfSections            = 1
            collectionView.backgroundView = nil
        } else {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text          =  PopupMessages.nodata
            noDataLabel.textColor     = UIColor.init(hexString: HexColorApp.gray)
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        }
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return permissions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransportViewCell.identifier, for: indexPath as IndexPath) as! TransportViewCell
        cell.setData(data: permissions[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        if let vc = UIStoryboard.init(name: "Lorry", bundle: Bundle.main).instantiateViewController(withIdentifier: "LorryListViewController") as? LorryListViewController {
        //            navigationController?.pushViewController(vc, animated: true)
        //        }
        
    }
}

extension ProjectImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 2.5
        
        let numberOfItemsPerRow: CGFloat = 2.0
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
