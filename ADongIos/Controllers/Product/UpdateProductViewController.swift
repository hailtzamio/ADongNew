//
//  UpdateViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire

class UpdateProductViewController: BaseViewController {
    
    @IBOutlet weak var header: NavigationBar!
    var data:Product? = nil
    var isUpdate = true // if false Create
    @IBOutlet weak var tfBrand: RadiusTextField!
    @IBOutlet weak var tfCapacity: RadiusTextField!
    @IBOutlet weak var tfPlateNumber: RadiusTextField!
    @IBOutlet weak var tfModel: RadiusTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        
        if(data != nil) {
            tfBrand.text = data?.name
            tfCapacity.text = data?.code
            tfPlateNumber.text = data?.createdByFullName
            tfModel.text = data?.updatedByFullName
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
    
    func checkValidate() {
        if ( tfBrand.text == "" || tfCapacity.text == "" || tfPlateNumber.text == "" || tfModel.text == "") {
            showToast(content: "Nhập thiếu thông tin")
            return
        }
    }
    
    @IBAction func createOrUpdate(_ sender: Any) {
        
        if(data == nil) {
            return
        }
        
        if ( tfBrand.text == "" || tfCapacity.text == "" || tfPlateNumber.text == "" || tfModel.text == "") {
            showToast(content: "Nhập thiếu thông tin")
            return
        }
        
        let dataRq = Lorry()
        dataRq.brand = tfBrand.text
        dataRq.model = tfModel.text
        dataRq.plateNumber = tfPlateNumber.text
        dataRq.capacity = tfCapacity.text
        
        if(isUpdate) {
            // Update
            update(pData: dataRq)
        } else {
            // Create
            
        }
    }
    
    func update(pData:Lorry) {
        
//        showLoading()
//        APIClient.updateLorryTest { result in
//            self.stopLoading()
//            switch result {
//            case .success(let response):
//
//                if response.status == 1 {
//                    self.showToast(content: "Thanh Cong")
//                    self.goBack()
//                    return
//                } else {
//                    self.showToast(content: response.message!)
//                }
//
//            case .failure(let error):
//                self.showToast(content: error.localizedDescription)
//            }
//        }
    }
}
