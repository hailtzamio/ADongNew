//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class CreateProductReqViewController: BaseViewController {
    
    var data = [Product]()
    var projectId = 0
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    //
    var isHideTf = true
    var createProductReq = CreateProductReq()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CountViewCell.nib, forCellReuseIdentifier: CountViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Vật Tư"
        
        if(!isHideTf) {
            header.changeDoneIcon()
        }
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if(self.isHideTf) {
                if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateProductViewController") as? UpdateProductViewController {
                    vc.isUpdate = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                /// Create
                var lines = [Product]()
                self.data.forEach { (value) in
                    if(value.count != nil) {
                        value.productId = value.id
                        value.quantity = Int(value.count!) ?? 0
                        lines.append(value)
                    }
                }
                
                self.createProductReq.expectedDatetime = "2020-10-10T12:12:12"
                self.createProductReq.projectId = self.projectId
                self.createProductReq.linesAddNew = lines
                
                self.createProductRequirement()
            }
            
        }
    }
    
    func createProductRequirement() {
        //       showLoading()
        APIClient.createProductRequirement(data : createProductReq) { result in
            //            self.stopLoading()
            switch result {
            case .success(let response):
                 self.showToast(content: response.message ?? "Thành công")
                if(response.status == 1) {
                    self.goBack()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getData() {
        showLoading()
        APIClient.getProducts(page : 0, name : "") { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data = response.data!
                    self.tbView.reloadData()
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension CreateProductReqViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountViewCell.identifier, for: indexPath) as! CountViewCell
        cell.tf1.isHidden = isHideTf
        if(!isHideTf) {
            cell.tf1.tag = indexPath.row
            cell.tf1.delegate = self
        }
        cell.setDataProduct(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!isHideTf) {
            return
        }
        
        if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailProductViewController") as? DetailProductViewController {
            vc.id = data[indexPath.row].id!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension  CreateProductReqViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print(textField.text)
        //        let quantity = (textField.text ?? "0") as Int
        data[textField.tag].count = textField.text!
    }
    
}
