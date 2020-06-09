//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher

class DetailTeamViewController: BaseViewController {
    var id = 0
    var item:Team? = nil
    var itemNames = ["THÔNG TIN CƠ BẢN ", "DANH SÁCH CÔNG NHÂN ( + ) "]
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    var data = [Information]()
    var workers = [Worker]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        tbView.register(SmallInformationViewCell.nib, forCellReuseIdentifier: SmallInformationViewCell.identifier) 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
                        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateTeamViewController") as? UpdateTeamViewController {
                            vc.data = self.item!
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeTeam(id: self.id) { result in
                self.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self.goBack()
                    }
                    self.showToast(content: response.message ?? "")
                    break
                    
                case .failure(let error):
                    self.showToast(content: error.localizedDescription)
                }
            }
        }
        
    }
    
    func getData() {
        
        data.removeAll()
        workers.removeAll()
        
        showLoading()
        APIClient.getTeam(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    self.convertData(value: value)
                    
                    self.data.append(Information(pKey: "Tên",pValue: value.name ?? "---"))
          
              
                    self.data.append(Information(pKey: "Địa chỉ",pValue: value.address ?? "---"))
                    
                    self.data.append(Information(pKey: "Số điện thoại",pValue: value.phone ?? "---"))
                    
                    self.data.append(Information(pKey: "Số điện thoại 2",pValue: value.phone2 ?? "---"))
                    
                    self.getTeamLeader(id: value.leaderId ?? 1)
                    
                    return
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func getTeamWorkers() {
        self.stopLoading()
        APIClient.getTeamWorkers(id : id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.workers.append(contentsOf: response.data!)
                    self.tbView.reloadData()
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    private func convertData(value:Team) {
        if(value.address == "") {
            value.address = nil
        }
        
        if(value.phone == "") {
            value.phone = nil
        }
        
        if(value.phone2 == "") {
            value.phone2 = nil
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        showYesNoPopup(title: "Xác nhận", message: "Chắc chắn xóa?")
    }
    
    func update(pData : Team) {
        self.stopLoading()
        APIClient.updateTeam(data : pData) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
                    //                    self.showToast(content: "Thành công")
                    self.getData()
                    return
                }else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
        
    }
    
    func getTeamLeader(id : Int) {
        showLoading()
        APIClient.getWorker(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.data.insert(Information(pKey: "Đội trưởng",pValue: value.fullName ?? "---"),at: 1)
                    self.getTeamWorkers()
                    return
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    
}

extension DetailTeamViewController: UITableViewDataSource, UITableViewDelegate {
    
    @objc func handleRegister(){
        if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
            vc.isToChooseWorker = true
            vc.team = item
            vc.workers = workers
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        sectionView.backgroundColor = UIColor.init(hexString: "#ffffff")
        
        let sectionName = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        sectionName.text = itemNames[section]
        sectionName.textColor = UIColor.init(hexString: "#4c4c4c")
        sectionName.font = UIFont.systemFont(ofSize: 17)
        sectionName.textAlignment = .left
        
        let uiButton = UIButton(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        uiButton.addTarget(self, action:#selector(handleRegister),
                           for: .touchUpInside)
        sectionView.addSubview(sectionName)
        sectionView.addSubview(uiButton)
        return sectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return data.count
        case 1:
            return workers.count
        default:
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
            cell.setData(data: data[indexPath.row])
            
            if(indexPath.row == data.count - 1) {
                cell.line.isHidden = true
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SmallInformationViewCell.identifier, for: indexPath) as! SmallInformationViewCell
            cell.setDataWorker(data: workers[indexPath.row])
            return cell
        default:
            print("no case found")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        case 1:
            return true
        default:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print("remove")
            workers.remove(at: indexPath.row)
            var memberIds = [Int]()
            for i in 0..<workers.count {
                memberIds.append(workers[i].id!)
            }
            
            item?.memberIds = memberIds
            update(pData: item!)
        }
    }
}

