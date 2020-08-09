//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class BaseInformationController: BaseViewController {
    var item = Project()
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var itemNames = ["THÔNG TIN CHUNG ", "THỜI GIAN","THÀNH VIÊN"]
    
    
    @IBOutlet weak var btnPauseAndResume: UIButton!
    var id = 0
    var data = [Information]()
    var data1 = [Information]()
    var data2 = [Information]()
    var project = Project()
    var status = "PAUSED"
    var isHideButtonRegister = false
    var notificationType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        
        tbView.register(LineViewCell.nib, forCellReuseIdentifier: LineViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        data1.removeAll()
        data2.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateProjectViewController") as? UpdateProjectViewController {
                vc.project = self.item
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if(notificationType != "" || isHideButtonRegister) {
            header.isRightButtonHide = true
        }
        
        btnPauseAndResume.isHidden = isHideButtonRegister
        header.changeUpdateIcon()
    }
    
    func registerProject() {
        self.showLoading()
        APIClient.registerProject(id: self.id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                if (response.status == 1) {
                    self.goBack()
                } else {
                self.showToast(content: response.message ?? "Không thành công")
                }
                break
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func popupHandle() {
        okAction = {
            
            if(self.notificationType == NotificationType.new) {
                self.registerProject()
            } else {
                if(self.status == "PAUSED") {
                    self.showLoading()
                    APIClient.resumeProject(data: self.item) { result in
                        self.stopLoading()
                        switch result {
                        case .success(let response):
                            if (response.status == 1) {
                                self.getData()
                            }
                            break
                            
                        case .failure(let error):
                            self.showToast(content: error.localizedDescription)
                        }
                    }
                } else {
                    self.showLoading()
                    APIClient.pauseProject(id: self.id) { result in
                        self.stopLoading()
                        switch result {
                        case .success(let response):
                            if (response.status == 1) {
                                self.getData()
                            } else {
                                self.showToast(content: response.message ?? "Không thành công")
                                }
                            break
                            
                        case .failure(let error):
                            self.showToast(content: error.localizedDescription)
                        }
                    }
                }
            }
            
            
            
            
            
        }
        
    }
    
    func getData() {
        showLoading()
        APIClient.getProject(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    self.data.removeAll()
                    self.data1.removeAll()
                    self.data2.removeAll()
                    self.status = value.status ?? ""
                    
                    self.data.append(Information(pKey: "Tên",pValue: value.name!))
                    self.data.append(Information(pKey: "Địa chỉ", pValue: value.address!))
                    
                    
                    if(self.notificationType == NotificationType.new) {
                        self.btnPauseAndResume.setTitle("Đăng Ký", for: .normal)
                    } else {
                        if(value.status == "PAUSED") {
                            self.btnPauseAndResume.setTitle("Phục Hồi", for: .normal)
                            self.data.append(Information(pKey: "Trạng thái", pValue: "Tạm dừng"))
                        } else if(value.status == "PROCESSING") {
                            self.btnPauseAndResume.setTitle("Tạm Dừng", for: .normal)
                            self.data.append(Information(pKey: "Trạng thái", pValue: "Đang thi công"))
                        } else if(value.status == "NEW") {
                            self.btnPauseAndResume.setTitle("Tạm Dừng", for: .normal)
                            self.data.append(Information(pKey: "Trạng thái", pValue: "Mới"))
                        }
                        else {
                            self.data.append(Information(pKey: "Trạng thái", pValue: "Hoàn Thành"))
                            self.btnPauseAndResume.isHidden = true
                        }
                    }
                    
                    
                    self.data1.append(Information(pKey: "Ngày bắt đầu",pValue: "".convertDateFormatter(date: value.plannedStartDate ?? "11/11/2020T11:11:11")))
                    self.data1.append(Information(pKey: "Ngày kết thúc",pValue: "".convertDateFormatter(date: value.plannedEndDate ?? "11/11/2020T11:11:11")))
                    
                    if(value.teamType == "ADONG") {
                        self.data2.append(Information(pKey: "Đội thi công",pValue: "Đội Á đông"))
                        self.data2.append(Information(pKey: "Tên đội",pValue: value.teamName ?? "---"))
                        self.data2.append(Information(pKey: "Đội trưởng",pValue: value.teamLeaderFullName ?? "---"))
                        
                    } else {
                        self.data2.append(Information(pKey: "Nhà thầu phụ",pValue: value.contractorName  ?? "---"))
//                        self.data2.append(Information(pKey: "Giám sát",pValue: value.supervisorFullName  ?? "---"))
                    }
                    
                    if(self.notificationType != "") {
                        if(value.investorContacts != nil && value.investorContacts?.manager != nil) {
                            self.data2.append(Information(pKey: "Trưởng bộ phận",pValue: value.investorContacts?.manager?.name ?? "---"))
                        }
                        
                        if(value.investorContacts != nil && value.investorContacts?.deputyManager != nil) {
                            self.data2.append(Information(pKey: "Phó bộ phận",pValue: value.investorContacts?.deputyManager?.name ?? "---"))
                        }
                    }
                    
                    self.data2.append(Information(pKey: "Quản lý vùng",pValue: value.supervisorFullName ?? "---"))
                    self.data2.append(Information(pKey: "Thư Ký",pValue: value.secretaryFullName ?? "---"))
                    
                    
                    
                    
                    
                    self.tbView.reloadData()
                    
                    
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
    }
    
    
    @IBAction func pauseProject(_ sender: Any) {
        if(notificationType == NotificationType.new) {
            showYesNoPopup(title: "Xác nhận", message: "Đăng ký thi công?")
        } else {
            if(self.status == "PROCESSING") {
                showYesNoPopup(title: "Xác nhận", message: "Tạm dừng công trình?")
            } else{
                showYesNoPopup(title: "Xác nhận", message: "Phục hồi công trình?")
                
            }
        }
    }
    
    @IBAction func viewMap(_ sender: Any) {
        let vc = MapViewController()
        vc.data = item
        vc.isJustView = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension BaseInformationController: UITableViewDataSource, UITableViewDelegate {
    
    
    @objc func handleRegister(){
        if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        sectionView.backgroundColor = UIColor.init(hexString: "#ffffff")
        
        let sectionName = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        sectionName.text = itemNames[section]
        sectionName.textColor = UIColor.init(hexString: HexColorApp.orange)
        sectionName.font = UIFont.systemFont(ofSize: 17)
        sectionName.textAlignment = .left
        sectionName.font = UIFont.boldSystemFont(ofSize: 16)
        
        let uiButton = UIButton(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        uiButton.addTarget(self, action:#selector(handleRegister),
                           for: .touchUpInside)
        sectionView.addSubview(sectionName)
        sectionView.addSubview(uiButton)
        return sectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return data.count
        case 1:
            return data1.count
        case 2:
            return data2.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.imv1.isHidden = true
        
        switch (indexPath.section) {
        case 0:
            cell.setData(data: data[indexPath.row])
            if(indexPath.row == data.count - 1) {
                cell.line.isHidden = true
            }
            break
        case 1:
            cell.setData(data: data1[indexPath.row])
            if(indexPath.row == data1.count - 1) {
                cell.line.isHidden = true
            } else {
                cell.line.isHidden = false
            }
            break
        case 2:
            cell.setData(data: data2[indexPath.row])
            if(indexPath.row == data2.count - 1) {
                cell.line.isHidden = true
            } else {
                cell.line.isHidden = false
            }
            break
            //        case 1,3 :
            //            let cell = tableView.dequeueReusableCell(withIdentifier: LineViewCell.identifier, for: indexPath) as! LineViewCell
            //            return cell
            
        default :
            break
        }
        return cell
    }
}
