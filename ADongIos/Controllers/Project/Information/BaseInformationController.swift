//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class BaseInformationController: BaseViewController {
    var item:Project? = nil
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var itemNames = ["THÔNG TIN CHUNG ", "", "THỜI GIAN", "", "THÀNH VIÊN"]
    
    
    var id = 0
    var data = [Information]()
    var data1 = [Information]()
    var data2 = [Information]()
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
        getData()
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        //        header.rightAction = {
        //            if let vc = UIStoryboard.init(name: "Lorry", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController {
        //                vc.data = self.item
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeLorry(id: self.id) { result in
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
        showLoading()
        APIClient.getProject(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    self.data.append(Information(pKey: "Tên",pValue: value.name!))
                    self.data.append(Information(pKey: "Địa chỉ", pValue: value.address!))
                    
                    
                    self.data1.append(Information(pKey: "Ngày bắt đầu",pValue: value.plannedStartDate ?? "---"))
                    self.data1.append(Information(pKey: "Ngày kết thúc",pValue: value.plannedEndDate ?? "---"))
                    
                    if(value.teamType == "ADONG") {
                        self.data2.append(Information(pKey: "Đội thi công",pValue: "Đội Á đông"))
                           self.data2.append(Information(pKey: "Tên đội",pValue: value.teamName ?? "---"))
                        self.data2.append(Information(pKey: "Đội trưởng",pValue: value.teamLeaderFullName ?? "---"))
                     
                    } else {
                        self.data2.append(Information(pKey: "Nhà thầu phụ",pValue: value.contractorName  ?? "---"))
                         self.data2.append(Information(pKey: "Giám sát",pValue: value.supervisorFullName  ?? "---"))
                    }
                    
                 
                    
                    self.data2.append(Information(pKey: "Trưởng bộ phận",pValue: value.managerFullName ?? "---"))
                    
                    self.data2.append(Information(pKey: "Phó bộ phận",pValue: value.deputyManagerFullName ?? "---"))
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
}

extension BaseInformationController: UITableViewDataSource, UITableViewDelegate {
    
    
    @objc func handleRegister(){
        if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
            
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
//        sectionView.backgroundColor = UIColor.init(hexString: "#ffffff")
//
//        let sectionName = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
//        sectionName.text = itemNames[section]
//        sectionName.textColor = UIColor.init(hexString: "#4c4c4c")
//        sectionName.font = UIFont.systemFont(ofSize: 17)
//        sectionName.textAlignment = .left
//
//        let uiButton = UIButton(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
//        uiButton.addTarget(self, action:#selector(handleRegister),
//                           for: .touchUpInside)
//        sectionView.addSubview(sectionName)
//        sectionView.addSubview(uiButton)
//        return sectionView
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return data.count
        case 2:
            return data1.count
        case 4:
            return data2.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        
        
        switch (indexPath.section) {
        case 0:
            cell.setData(data: data[indexPath.row])
            if(indexPath.row == data.count - 1) {
                cell.line.isHidden = true
            }
            break
        case 2:
            cell.setData(data: data1[indexPath.row])
            if(indexPath.row == data1.count - 1) {
                cell.line.isHidden = true
            }
            break
        case 4:
            cell.setData(data: data2[indexPath.row])
            if(indexPath.row == data2.count - 1) {
                cell.line.isHidden = true
            }
            break
        case 1,3 :
            let cell = tableView.dequeueReusableCell(withIdentifier: LineViewCell.identifier, for: indexPath) as! LineViewCell
            return cell
            
        default :
            break
        }
        return cell
    }
}
