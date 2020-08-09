//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher
class DetailContractorViewController: BaseViewController {
    var id = 0
    var item:Contractor? = nil
    var data = [Information]()
    
    @IBOutlet weak var bt1: UIButton!
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var isToChoose = false
    var status = ""
    var biddingId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        
         header.isRightButtonHide = !Context.Permission.contains("u")
        
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Contractor", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateContractorViewController") as? UpdateContractorViewController {
                vc.data = self.item!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changeUpdateIcon()
        
        if(isToChoose) {
            header.isRightButtonHide = true
            bt1.setTitle("ĐỒNG Ý", for: .normal)
        } else {
            bt1.isHidden = !Context.Permission.contains("d")
        }
    }
    
    func popupHandle() {
        okAction = {
            if(self.isToChoose) {
                self.projectBiddingApprove()
            } else {
                self.showLoading()
                APIClient.removeContractor(id: self.id) { result in
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
        
    }
    
    func projectBiddingApprove() {
        
        showLoading()
        APIClient.projectBiddingApprove(id: biddingId) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
                    self.showToast(content: "Thành công")
                    self.goBack()
                    return
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func getData() {
        showLoading()
        APIClient.getContractor(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.convertData(value: value)
                    self.item = value
                    self.data.append(Information(pKey: "Tên",pValue: value.name!))
                    
                    self.data.append(Information(pKey: "Số điện thoại",pValue: value.phone!))
                    self.data.append(Information(pKey: "Email",pValue: value.email ?? "---"))
                    
                    var address = ""
                    
        
                        address = "\(value.districtName ?? "") - \(value.provinceName ?? "") - \(value.address ?? "") "
                
                    
                    self.data.append(Information(pKey: "Địa chỉ",pValue: address))
                    
                    var status = "---"
                    if(value.workingStatus == "idle") {
                        status = "Đang bận"
                    } else {
                        status = "Đang rảnh"
                    }
//                    self.data.append(Information(pKey: "Trạng thái",pValue: status))
                    self.data.append(Information(pKey: "Tên dự án",pValue: value.projectName ?? "---"))
                    
                    self.tbView.reloadData()
                    
                    if(self.isToChoose && self.status != "NEW") {
                        self.bt1.isHidden = true
                    } else {
                        self.bt1.isHidden = false
                    }
                    
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func convertData(value:Contractor) {
        if(value.email == "") {
            value.email = nil
        }
        
        if(value.address == "") {
            value.address = nil
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        if(isToChoose) {
            showYesNoPopup(title: "Xác nhận", message: "Chọn Nhà thầu phụ này?")
        } else {
            showYesNoPopup(title: "Xác nhận", message: "Chắc chắn xóa?")
        }
    }
    
}

extension DetailContractorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
}
