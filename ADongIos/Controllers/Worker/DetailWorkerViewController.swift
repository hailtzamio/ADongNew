//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher

class DetailWorkerViewController: BaseViewController {
    var id = 0
    var item:Worker? = nil
    
    @IBOutlet weak var imvAva: UIImageView!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbPosition: UILabel!
    
    @IBOutlet weak var lbPhone: UILabel!
    
    var data = [Information]()
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
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateWorkerViewController") as? UpdateWorkerViewController {
                vc.data = self.item!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeWorker(id: self.id) { result in
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
        let imageDf = UIImage(named: "default")
        APIClient.getWorker(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    print(value.address)
                    self.item = value
                    
                    self.convertData(value: value)
                
                    self.lbName.text = value.fullName ?? "---"
                    self.lbPhone.text = value.phone
                    
                    if(value.isTeamLeader ?? false) {
                        self.lbPosition.text = "Đội trưởng"
                    } else {
                        self.lbPosition.text = "Công nhân"
                    }
                    
             
                    self.data.append(Information(pKey: "Địa chỉ",pValue: value.address ?? "---"))
                    
                    self.data.append(Information(pKey: "Line ID",pValue: value.lineId ?? "---"))
                    
                    
                    if let status = value.workingStatus {
                        if(status == "working") {
                            self.data.append(Information(pKey: "Trạng thái",pValue: "Đang bận"))
                        } else {
                            self.data.append(Information(pKey: "Trạng thái",pValue: "Đang rảnh"))
                        }
                    } else {
                        self.data.append(Information(pKey: "Trạng thái",pValue: "---"))
                    }
                    
                    
                    self.data.append(Information(pKey: "Đội thi công",pValue: value.teamName ?? "---"))
                    
                    self.data.append(Information(pKey: "Ngân hàng",pValue: value.bankName ?? "---"))
                    
                    
                    self.data.append(Information(pKey: "Số tài khoản",pValue: value.bankAccount ?? "---"))
                    
                    let url = URL(string: value.avatarUrl ?? "")
                    self.imvAva.kf.setImage(with: url, placeholder: imageDf)
                    
                    self.tbView.reloadData()
                    return
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    private func convertData(value:Worker) {
        if(value.address == "") {
            value.address = nil
        }
        
        if(value.lineId == "") {
            value.lineId = nil
        }
        
        if(value.teamName == "") {
            value.teamName = nil
        }
        
        if(value.bankName == "") {
            value.bankName = nil
        }
        if(value.bankAccount == "") {
            value.bankAccount = nil
        }
    }
    
    
    
    @IBAction func remove(_ sender: Any) {
        showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
    }
}

extension DetailWorkerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
}

