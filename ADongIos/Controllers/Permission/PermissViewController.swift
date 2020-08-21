//
//  PermissViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/20/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PermissViewController: BaseViewController {
    
    @IBOutlet weak var notificationNum: UIButton!
    @IBOutlet weak var imv1: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var someProtocol = [String : Permission]()
    var permissions = [Permission]()
    var mainPermissions = [Permission]()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        collectionView.register(PermissionCollectionViewCell.nib, forCellWithReuseIdentifier: PermissionCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        //        K.ProductionServer.ACCESS_TOKEN = preferences.object(forKey: accessToken) as! String
        
        
     
        getMyRole()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(resetData), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        
        
        getMyProfile()
        getNotificationsNotSeen()
    }
    
    @objc func resetData() {
        getMyProfile()
        getNotificationsNotSeen()
    }
    
    func getData() {
        
        permissions.removeAll()
        
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
    
    var isContractor = false
        var rolesString = ""
    func getMyRole() {
        
        
        APIClient.getMyRoles{ result in
            self.stopLoading()
            switch result {
            case .success(let res):
                self.getData()
                if(res.data!.count > 0 ) {
                    
                
                    res.data!.forEach { (role) in
                        
//                        self.rolesString = self.rolesString + (role.name ?? "") + "-" + (role.code ?? "") + ","
                        if(role.code ?? "" == "CONTRACTOR") {
                            self.isContractor = true
                        }
                        
                        print(role.code ?? "")
                    
                    }
                    
                 
              
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupView(data:[Permission]) {
        mainPermissions = data
        data.forEach { (value) in
            self.someProtocol[value.appEntityCode ?? ""] = value
        }
        
        for (key, value) in self.someProtocol {
            if(key == "Product" || key == "Lorry" || key == "Worker" || key == "Team" || key == "Driver" || key == "Contractor" || key == "Project" || key == "Transport" || key == "Trip" || key == "Warehouse"   ) {
                self.permissions.append(value)
            }
        }
        
        let per = Permission()
        per.appEntityCode = "Bidding"
        self.permissions.append(per)
        
        self.collectionView.reloadData()
    }
    
    
    @IBAction func goToProfile(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func goToNotification(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController {
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension PermissViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return permissions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PermissionCollectionViewCell.identifier, for: indexPath as IndexPath) as! PermissionCollectionViewCell
        cell.setData(data: permissions[indexPath.row])
        cell.tbTitle.textColor = UIColor.init(hexString: HexColorApp.primary)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var vC = UIViewController()
        var actionString = ""
        mainPermissions.forEach { (permission) in
            
            print(permission.action)
            
            if(permissions[indexPath.row].appEntityCode == permission.appEntityCode) {
                actionString = actionString + "-" + (permission.action ?? "")
            }
        }
        
        Context.Permission = actionString
        
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
        case "Bidding":
            if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationsViewController") as? RegistrationsViewController {
                vC = vc
            }
            break
            
            
        default:
            break
        }
        
        vC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vC, animated: true)
        
        //        if let vc = UIStoryboard.init(name: "Lorry", bundle: Bundle.main).instantiateViewController(withIdentifier: "LorryListViewController") as? LorryListViewController {
        //            navigationController?.pushViewController(vc, animated: true)
        //        }
        
    }
}

extension PermissViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 2.5
        layout.minimumInteritemSpacing = 2.5
        
        let numberOfItemsPerRow: CGFloat = 2.0
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: 100)
    }
    
    func getMyProfile() {
        
        
        let imageDf = UIImage(named: "user_default")
        APIClient.getMyProfile { result in
            
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    let url = URL(string: value.avatarUrl ?? "")
                    self.imv1.kf.setImage(with: url, placeholder: imageDf)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func getNotificationsNotSeen() {
        
        APIClient.getNotificationsNotSeen { result in
            
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    
                    let notSeenCount = response.data!.notSeenCount ?? 0
                    if(notSeenCount > 0) {
                        self.notificationNum.isHidden = false
                        self.notificationNum.setTitle("\(notSeenCount)", for: .normal)
                    } else {
                        self.notificationNum.isHidden = true
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
