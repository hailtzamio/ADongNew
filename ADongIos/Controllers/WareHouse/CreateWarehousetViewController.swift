//
//  UpdateViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire

class CreateWarehousetViewController: BaseViewController, UINavigationControllerDelegate {
    
    

    
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
     @IBOutlet weak var tf3: RadiusTextField!
    
    @IBOutlet weak var header: NavigationBar!
    
    
    var data = Warehouse()
    var isUpdate = true // if false Create
    var type = "STOCK"
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        data.type = type
        if(isUpdate) {
            tf1.text = data.name
            tf2.text = data.address
        } else {
            
        }
        
    }
    
    @IBAction func chooseKeeper(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = true
            vc.isTypeOfWorker = TypeOfWorker.keeper
            vc.isRightButtonHide = true
            vc.callback = {(worker) in
                 self.data.keeperId = worker?.id
             self.tf3.text = worker?.fullName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupHeader() {
        header.title = "Cập Nhật"
        if(!isUpdate) {
            header.title = "Tạo Mới"
        }
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    
    @IBAction func createOrUpdate(_ sender: Any) {
          
    
          if ( tf1.text == "" || tf2.text == "" || tf3.text == "" ) {
              showToast(content: "Nhập thiếu thông tin")
              return
          }
          
          data.name = tf1.text
          data.address = tf2.text
          
          if(isUpdate) {
              // Update
              update(pData: data)
          } else {
              create(pData: data)
          }
      }
    
    func update(pData:Warehouse) {
        
        showLoading()
        APIClient.createWarehouse(data: pData) { result in
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
    
    func create(pData:Warehouse) {
        
        if(tf1.text == "" || tf2.text == "" ) {
            showToast(content: "Chọn ngày")
            return
        }

    
        showLoading()
        APIClient.createWarehouse(data: pData) { result in
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
}



