//
//  PermissViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/20/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class PermissViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var someProtocol = [String : Permission]()
    var permissions = [Permission]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        collectionView.register(PermissionCollectionViewCell.nib, forCellWithReuseIdentifier: PermissionCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        //        K.ProductionServer.ACCESS_TOKEN = preferences.object(forKey: accessToken) as! String
        
        getData() 
        
    }
    
    func getData() {
        showLoading()
        APIClient.getPermissions{ result in
            self.stopLoading()
            switch result {
            case .success(let articles):
                
                if(articles.data != nil) {
                    self.setupView(data: articles.data!)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupView(data:[Permission]) {
        
        data.forEach { (value) in
            self.someProtocol[value.appEntityCode ?? ""] = value
        }
        
        for (key, value) in self.someProtocol {
            print(key)
            if(key == "Product" || key == "Lorry" || key == "Worker" || key == "Team" || key == "Driver" || key == "Contractor" || key == "Project" || key == "Transport" || key == "Trip" || key == "Warehouse"   ) {
                self.permissions.append(value)
            }
        }
        
        self.collectionView.reloadData()
    }
    
}

extension PermissViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return permissions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PermissionCollectionViewCell.identifier, for: indexPath as IndexPath) as! PermissionCollectionViewCell
        cell.setData(data: permissions[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var vC = UIViewController()
        switch permissions[indexPath.row].appEntityCode {
        case "Product":
            if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListProductViewController") as? ListProductViewController {
                vC = vc
            }
            break
        case "Lorry":
            if let vc = UIStoryboard.init(name: "Lorry", bundle: Bundle.main).instantiateViewController(withIdentifier: "LorryListViewController") as? LorryListViewController {
                vC = vc
            }
            break
        case "Worker":
            if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
                vC = vc
            }
            break
        case "Team":
            if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListTeamViewController") as? ListTeamViewController {
                vC = vc
            }
            break
        case "Driver":
            if let vc = UIStoryboard.init(name: "Driver", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListDriverViewController") as? ListDriverViewController {
                vC = vc
            }
            break
        case "Contractor":
            if let vc = UIStoryboard.init(name: "Contractor", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListContractorViewController") as? ListContractorViewController {
                vC = vc
            }
            break
        case "Project":
            if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListProjectViewController") as? ListProjectViewController {
                vC = vc
            }
            break
            
        case "Trip":
            if let vc = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "TripTransportViewController") as? TripTransportViewController {
                vC = vc
            }
            break
        case "Warehouse":
            if let vc = UIStoryboard.init(name: "Warehouse", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailWareHouseViewController") as? DetailWareHouseViewController {
                vC = vc
            }
            break
            
            
        default:
            break
        }
        
        navigationController?.pushViewController(vC, animated: true)
        
        //        if let vc = UIStoryboard.init(name: "Lorry", bundle: Bundle.main).instantiateViewController(withIdentifier: "LorryListViewController") as? LorryListViewController {
        //            navigationController?.pushViewController(vc, animated: true)
        //        }
        
    }
}

extension PermissViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 2.5
        
        let numberOfItemsPerRow: CGFloat = 2.0
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: 100)
    }
}
