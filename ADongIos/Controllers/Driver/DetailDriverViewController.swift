//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher
class DetailDriverViewController: BaseViewController {
    var id = 0
    var item:Driver? = nil
    var data = [Information]()
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    @IBOutlet weak var imvAva: UIImageView!
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
            if let vc = UIStoryboard.init(name: "Driver", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateDriverViewController") as? UpdateDriverViewController {
                vc.data = self.item!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeDriver(id: self.id) { result in
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
        APIClient.getDriver(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.convertData(value: value)
                    self.item = value
                    self.data.append(Information(pKey: "Họ tên",pValue: value.fullName!))
                    self.data.append(Information(pKey: "Số điện thoại",pValue: value.phone!))
                    self.data.append(Information(pKey: "Email",pValue: value.email ?? "---"))
                    self.data.append(Information(pKey: "Chuyến đi",pValue: value.tripName ?? "---"))
                    
                    let imageDf = UIImage(named: "default")
                    let url = URL(string: value.avatarUrl ?? "")
                    self.imvAva.kf.setImage(with: url, placeholder: imageDf)
          
                    self.tbView.reloadData()
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func convertData(value:Driver) {
          if(value.email == "") {
              value.email = nil
          }
          
          if(value.phone2 == "") {
              value.phone2 = nil
          }
          
          if(value.tripName == "") {
              value.tripName = nil
          }
      }
    
    @IBAction func remove(_ sender: Any) {
        showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
    }
}

extension DetailDriverViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
}
