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
            @IBOutlet weak var tf1: RadiusTextField!
            @IBOutlet weak var tf2: RadiusTextField!
            @IBOutlet weak var tf3: RadiusTextField!
            @IBOutlet weak var tf4: RadiusTextField!
            var productType = ""
            override func viewDidLoad() {
                super.viewDidLoad()
                hideKeyboardWhenTappedAround()
                setupHeader()
                
                if(data != nil) {
                    tf1.text = data?.name
                    tf2.text = data?.code
                    tf3.text = data?.unit
                    
                    switch data?.type {
                    case "buy":
                        tf4.text = "Mua"
                        productType = "buy"
                        break
                    case "manufacture":
                        tf4.text = "Xuất kho"
                          productType = "manufacture"
                        break
                    case "tool":
                        tf4.text = "Sản xuất"
                                productType = "tool"
                        break
                    default:
                        break
                    }
                    
                }
            }
            
        
            
            @IBAction func productType(_ sender: Any) {
                showTakePhotoPopup()
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
                
                let dataRq = Product()
                dataRq.name = tf1.text
                dataRq.type = productType
                dataRq.unit = tf3.text
                dataRq.code = tf2.text
                
                
                if(isUpdate) {
                    // Update
                    dataRq.id = data?.id ?? 0
                    update(pData: dataRq)
                } else {
                    // Create
                    create(pData: dataRq)
                }
            }
            
            func create(pData:Product) {
                
                showLoading()
                APIClient.createProduct(data : pData) { result in
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
            
            func update(pData:Product) {
                
                showLoading()
                APIClient.updateProduct(data : pData) { result in
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
            
            func showTakePhotoPopup() {
                
                let alert = UIAlertController(title: "Tùy chọn", message: "", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Mua", style: .default , handler:{ (UIAlertAction)in
                    self.productType = "buy"
                    self.tf4.text = "Mua"
                }))
                
                alert.addAction(UIAlertAction(title: "Xuất kho", style: .default , handler:{ (UIAlertAction)in
                    self.productType = "manufacture"
                    self.tf4.text = "Xuất kho"
                }))
                
                alert.addAction(UIAlertAction(title: "Sản xuất", style: .default , handler:{ (UIAlertAction)in
                    self.productType = "tool"
                    self.tf4.text = "Sản xuất"
                }))
                
                //        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                //            print("User click Delete button")
                //        }))
                
                alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
                    print("User click Dismiss button")
                }))
                
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
            }
        }
