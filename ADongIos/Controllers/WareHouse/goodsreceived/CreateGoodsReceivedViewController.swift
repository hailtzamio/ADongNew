//
//  UpdateViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire

class CreateGoodsReceivedViewController: BaseViewController, UINavigationControllerDelegate {
    

    
    @IBOutlet weak var tf1: RadiusTextField!
     @IBOutlet weak var tf2: RadiusTextField!
      @IBOutlet weak var tf3: RadiusTextField!
    @IBOutlet weak var tf4: RadiusTextField!
    
    @IBOutlet weak var header: NavigationBar!
    
    
    var data = GoodsReceivedNote()
    var isUpdate = true // if false Create
    var type = "STOCK"
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
  
        if(isUpdate) {
            tf1.text = data.deliveredBy
            tf2.text = data.ref
        } else {
            
        }
        
    }
    
    @IBAction func chooseKeeper(_ sender: Any) {
           if let vc = UIStoryboard.init(name: "Warehouse", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListStockViewController") as? ListStockViewController {
            vc.isChooseWarehouse = true
               vc.callback = {(warehouse) in
                    self.data.warehouseId = warehouse?.id
                self.tf4.text = warehouse?.name
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
             
             if ( tf1.text == "" || tf2.text == "" || tf3.text == "" || tf4.text == "") {
                 showToast(content: "Nhập thiếu thông tin")
                 return
             }
             
             data.deliveredBy = tf1.text
             data.ref = tf2.text
             data.note = tf3.text
             
        if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListProductViewController") as? ListProductViewController {
            vc.goodsReceivedNote = data
            vc.isHideTf = false
               self.navigationController?.pushViewController(vc, animated: true)
           }
         }
}



