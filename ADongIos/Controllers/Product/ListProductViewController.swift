//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ListProductViewController: BaseViewController {
    
    var data = [Product]()
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    //
    var isHideTf = true
    var goodsReceivedNote = GoodsReceivedNote()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(ProductCell.nib, forCellReuseIdentifier: ProductCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        
        header.isRightButtonHide = !Context.Permission.contains("c")
        
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
                
                self.goodsReceivedNote.lines = lines
                
                self.createGoodsReceivedNote()
            }
            
        }
    }
    
    func createGoodsReceivedNote() {
//       showLoading()
        APIClient.createGoodsReceivedNote(data : goodsReceivedNote) { result in
//            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.status == 1) {
                  self.showToast(content: response.message ?? "Thành công")
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

extension ListProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
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

extension  ListProductViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print(textField.text)
        //        let quantity = (textField.text ?? "0") as Int
        data[textField.tag].count = textField.text!
    }

}
