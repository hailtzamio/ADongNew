//
//  UpdateViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TOCropViewController
class UpdateProfileViewController: BaseViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var header: NavigationBar!
    var data = Worker()

    
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
    @IBOutlet weak var tf3: RadiusTextField!
    @IBOutlet weak var tf4: RadiusTextField!
    var avatarData:Data? = nil
    var avatarExtId = ""
    var isLeader = false
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        
           tf1.text = data.fullName
           tf2.text = data.phone
           tf3.text = data.email
           tf4.text = data.address
    }
    

    func setupHeader() {
        header.title = "Cập Nhật"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    @IBAction func createOrUpdate(_ sender: Any) {
           
           if ( tf1.text == "" || tf2.text == "" ) {
               showToast(content: "Nhập thiếu thông tin")
               return
           }
        
           data.fullName = tf1.text
           data.phone = tf2.text
           data.email = tf3.text
           data.address = tf4.text
    
            update(pData: data)
       }
    
   
    
    func update(pData:Worker) {
        
         showLoading()
        APIClient.updateProfile(data: pData) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
                    self.showToast(content: "Thành công")
                    self.goBack()
                    return
                } else {
                    self.showToast(content: response.message ?? "Không thành công")
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    
}




