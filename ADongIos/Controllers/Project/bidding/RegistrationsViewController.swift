//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class RegistrationsViewController: BaseViewController {
    
    
    var data = [Project]()
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(ProjectViewCell.nib, forCellReuseIdentifier: ProjectViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Nhà Thầu Phụ"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    func getData() {
        showLoading()
        APIClient.getRegistrations { result in
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

extension RegistrationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViewCell.identifier, for: indexPath) as! ProjectViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setDataRegistration(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkIsRegisterOrNot(projectId: data[indexPath.row].id!)
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
