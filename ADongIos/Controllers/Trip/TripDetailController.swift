//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class TripDetailController: BaseViewController {
    var item:Trip? = nil
    
    
    var itemNames = ["DANH SÁCH YCVC","THÔNG TIN CHUNG"]
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    var id = 0
    var data = [Information]()
    var data1 = [Transport]()
    
    
    
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
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransportImagesViewController") as? TransportImagesViewController {
                vc.id = self.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changePhotoIcon()
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
        APIClient.getTrip(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    self.data.append(Information(pKey: "Tên",pValue: value.name!))
                    self.data.append(Information(pKey: "Tài xế", pValue: value.driverFullName!))
                    self.data.append(Information(pKey: "Số điện thoại", pValue: value.driverPhone!))
                    self.data.append(Information(pKey: "Tạo bởi", pValue: value.createdByFullName!))
                    self.data.append(Information(pKey: "Tạo lúc", pValue: "".convertDateFormatter(date: value.createdTime!)))
                    
                    if(value.transportRequests != nil) {
                        self.data1 = value.transportRequests!
                    }
                    
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

extension TripDetailController: UITableViewDataSource, UITableViewDelegate {
    
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return data1.count
        case 1:
            return data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch (indexPath.section) {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
            cell.setData(data: data[indexPath.row])
                 cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if(indexPath.row == data.count - 1) {
                cell.line.isHidden = true
            }
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: WareHouseViewCell.identifier, for: indexPath) as! WareHouseViewCell
            cell.setData(data: data1[indexPath.row])
            //            if(indexPath.row == data1.count - 1) {
            //                cell.line.isHidden = true
            //            }
                 cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0) {
            
            if let vc = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransportDetailController") as? TransportDetailController {
                vc.id = data1[indexPath.row].id!
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        
    }
}
