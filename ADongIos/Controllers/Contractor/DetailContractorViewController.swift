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
    @IBOutlet weak var tbView: UITableView!
       @IBOutlet weak var header: NavigationBar!
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
            if let vc = UIStoryboard.init(name: "Contractor", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateContractorViewController") as? UpdateContractorViewController {
                vc.data = self.item!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
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
    
    func getData() {
        showLoading()
        APIClient.getContractor(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.convertData(value: value)
                    self.item = value
                    self.data.append(Information(pKey: "Họ tên",pValue: value.name!))
                    self.data.append(Information(pKey: "Địa chỉ",pValue: value.address ?? "---"))
                    self.data.append(Information(pKey: "Số điện thoại",pValue: value.phone!))
                    self.data.append(Information(pKey: "Email",pValue: value.email ?? "---"))
               
                    
          
                    self.tbView.reloadData()
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
         showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
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
