//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class DetailProductViewController: BaseViewController {
    var id = 0
    var item:Product? = nil
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var data = [Information]()
    @IBOutlet weak var imvAva: UIImageView!
    var thumbnailExtId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
              
                   getData()
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateProductViewController") as? UpdateProductViewController {
                vc.data = self.item
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeProduct(id: self.id) { result in
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
        APIClient.getProduct(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    
                    self.data.removeAll()
                    
                    self.data.append(Information(pKey: "Tên",pValue: value.name ?? "---"))
                    self.data.append(Information(pKey: "Mã",pValue: value.code ?? "---"))
                    
                    var type = ""
                    switch value.type {
                    case "buy":
                        type = "Mua"
                        break
                    case "manufacture":
                        type = "Sản xuất"
                        break
                    case "tool":
                        type = "Xuất kho"
                        break
                    default:
                        break
                    }
                    
                    self.thumbnailExtId = value.thumbnailUrl ?? ""
                    let url = URL(string: self.thumbnailExtId)
                    self.imvAva.kf.setImage(with: url, placeholder: UIImage(named: "default"))
                    
                    
              
                    self.data.append(Information(pKey: "Đơn vị tính",pValue: value.unit ?? "---"))
                    self.data.append(Information(pKey: "Loại",pValue: type))
                    self.data.append(Information(pKey: "Chiều dài",pValue: String(value.length ?? 0.0)))
                     self.data.append(Information(pKey: "Chiều rộng",pValue: String(value.width ?? 0.0)))
                     self.data.append(Information(pKey: "Chiều cao",pValue: String(value.height ?? 0.0)))
                     self.data.append(Information(pKey: "Cân nặng",pValue: String(value.weight ?? 0.0)))
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

extension DetailProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
}
