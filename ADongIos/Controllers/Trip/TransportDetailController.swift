//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class TransportDetailController: BaseViewController {
    var item:Transport? = nil
    
    
    var itemNames = ["THÔNG TIN CHUNG", "DANH SÁCH VẬT TƯ"]
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var id = 0
    var data = [Information]()
    var data1 = [Information]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        tbView.register(WareHouseViewCell.nib, forCellReuseIdentifier: WareHouseViewCell.identifier)
        
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
            APIClient.transportPickup(id: self.id) { result in
                self.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self.goBack()
                    }
                    self.showToast(content: response.message ?? "Thành công")
                    break
                    
                case .failure(let error):
                    self.showToast(content: error.localizedDescription)
                }
            }
            
        }
        
    }
    
    func getData() {
        showLoading()
        APIClient.getTransport(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    self.data.append(Information(pKey: "Code",pValue: value.code!))
                    self.data.append(Information(pKey: "Kho / Xưởng", pValue: value.warehouseName!))
                    self.data.append(Information(pKey: "Tên dự án", pValue: value.projectName!))
                    
                    if(value.lines != nil) {
                        value.lines?.forEach({ (t) in
                            let quantity = t.quantity ?? 0
                            let model = Information(pKey: "\(quantity)" ,pValue: t.productName!)
                            self.data1.append(model)
                        })
                    }
                    
                    
                    
                    self.tbView.reloadData()
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        showYesNoPopup(title: "Xác nhận", message: "Đã nhận hàng?")
    }
}

extension TransportDetailController: UITableViewDataSource, UITableViewDelegate {
    
    
    @objc func handleRegister(){
        if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
            
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
            return data1.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
            cell.setData(data: data[indexPath.row])
            if(indexPath.row == data.count - 1) {
                cell.line.isHidden = true
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
            cell.setData(data: data1[indexPath.row])
            //            if(indexPath.row == data1.count - 1) {
            //                cell.line.isHidden = true
            //            }
            return cell
        default:
            break
        }
        return cell
    }
}