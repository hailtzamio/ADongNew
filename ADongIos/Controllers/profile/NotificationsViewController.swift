//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    
    var data = [NotificationOb]()
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CommonNoAvatarCell.nib, forCellReuseIdentifier: CommonNoAvatarCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Thông Báo"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    func getData() {
        showLoading()
        APIClient.getNotifications { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data = response.data!
                    self.tbView.reloadData()
                    
                    if(response.data?.count == 0) {
                        self.showNoDataMessage(tbView: self.tbView)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension NotificationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonNoAvatarCell.identifier, for: indexPath) as! CommonNoAvatarCell
        
        cell.setDataNotification(data: data[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.imv1.image = UIImage(named:  "bell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readNotification(id: data[indexPath.row].id!)
          checkIsRegisterOrNot(projectId: data[indexPath.row].objectId!)
//        if(data[indexPath.row].objectType == "Project") {
//            if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BaseInformationController") as? BaseInformationController {
//                vc.id = data[indexPath.row].objectId!
//                vc.notificationType =  data[indexPath.row].type ?? ""
//                navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
    
    func readNotification(id : Int) {
        
        showLoading()
        APIClient.getNotification(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    print("Đã đọc Notification")
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func checkIsRegisterOrNot(projectId : Int) {
          
          let userId =  self.preferences.object(forKey: userIdKey) ?? 0
          
          showLoading()
          APIClient.getProjectIsregister(projectId: projectId, contractorId: userId as! Int) { result in
              self.stopLoading()
              switch result {
              case .success(let response):
                  
                  if let value = response.data  {
                      if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BaseInformationController") as? BaseInformationController {
                          vc.id = projectId
                          vc.notificationType =  NotificationType.new
                          vc.isHideButtonRegister = value.isRegistered ?? false
                          self.navigationController?.pushViewController(vc, animated: true)
                      }
                  } else {
                  
                      self.showToast(content: "Bạn không phải Nhà thầu phụ")
                  }
                  
                  
                  
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
          
          
          
      }
}
