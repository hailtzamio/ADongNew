//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ProductRequirementViewController: BaseViewController {
    
    var data = [GoodsReceivedNote]()
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Yêu Cầu Vật Tư"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateProductReqViewController") as? CreateProductReqViewController {
                vc.isHideTf = false
                vc.projectId = self.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func getData() {
        showLoading()
        APIClient.getProductRequirements(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data = response.data!
                    self.tbView.reloadData()
                    
                    if(response.data?.count == 0) {
                        self.showNoDataMessage(tbView: self.tbView)
                    } else {
                        self.hideNoDataMessage(tbView: self.tbView)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeProductRequirement(productRequirementId: Int) {
        self.showLoading()
        APIClient.removeProductRequirement(id: productRequirementId) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                if (response.status == 1) {
                    self.showToast(content: "Thành công")
                    self.getData()
                } else {
                    self.showToast(content: response.message ?? "error")
                }
                break
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
}

extension ProductRequirementViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.setDataProductRequirement(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailProductRequirementViewController") as? DetailProductRequirementViewController {
            vc.goodsReceivedNote = data[indexPath.row]
            vc.id = data[indexPath.row].id!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete
        let delete = UIContextualAction(style: .normal, title: "Xoá") { [self] (action, view, completionHandler) in
            self.removeProductRequirement(productRequirementId: self.data[indexPath.row].id!)
            completionHandler(true)
        }
        if #available(iOS 13.0, *) {
            delete.image = UIImage(systemName: "Compose")
        } else {
            // Fallback on earlier versions
        }
        delete.backgroundColor = .red
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
        
    }
}
