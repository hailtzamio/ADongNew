//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher

class DetailProductRequirementViewController: BaseViewController {
    var id = 0
    var item:Team? = nil
    var itemNames = ["THÔNG TIN CƠ BẢN ", "DANH SÁCH VẬT TƯ"]
    
    var goodsReceivedNote = GoodsReceivedNote()
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    var data = [Information]()
    var data2 = [Product]()
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
        if(goodsReceivedNote.id != nil) {
            getData()
        } else {
            getDataFromApi()
        }
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
        
        header.changeUpdateIcon()
    }
    
    func getDataFromApi() {
        self.showLoading()
        APIClient.getProductRequirement(id: self.id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                if (response.status == 1 && response.data != nil) {
                    self.goodsReceivedNote = response.data!
                    self.getData()
                }
                break
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
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
        data2.removeAll()
        self.data.append(Information(pKey: "Code",pValue: goodsReceivedNote.code ?? "---"))
        
        self.data.append(Information(pKey: "Ngày dự kiến",pValue: "".convertDateFormatter(date: goodsReceivedNote.expectedDatetime ?? "---")))
        
        self.data.append(Information(pKey: "Ghi chú",pValue: goodsReceivedNote.note ?? "---"))
        
        self.data2 = goodsReceivedNote.lines ?? [Product]()
        
        tbView.reloadData()
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
    
}

extension DetailProductRequirementViewController: UITableViewDataSource, UITableViewDelegate {
    
    @objc func handleRegister(){
//        if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListProductViewController") as? ListProductViewController {
//
//            vc.data = data2
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        sectionView.backgroundColor = UIColor.init(hexString: "#ffffff")
        
        let sectionName = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        sectionName.text = itemNames[section]
        sectionName.textColor = UIColor.init(hexString: "#fb9214")
        sectionName.font = UIFont.systemFont(ofSize: 17)
        sectionName.font = UIFont.boldSystemFont(ofSize: 16)
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
            return data2.count
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
            cell.setDataProduct(data: data2[indexPath.row])
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
            
        }
    }
}

