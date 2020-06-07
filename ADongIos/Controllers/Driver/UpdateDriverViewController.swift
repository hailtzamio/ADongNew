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
class UpdateDriverViewController: BaseViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var header: NavigationBar!
    var data = Driver()
    var isUpdate = true // if false Create
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
    @IBOutlet weak var tf3: RadiusTextField!
    @IBOutlet weak var tf4: RadiusTextField!
    @IBOutlet weak var imvAva: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        
        if(isUpdate) {
            tf1.text = data.fullName
            tf2.text = data.phone
            tf3.text = data.phone2
            tf4.text = data.email
            let url = URL(string: data.avatarUrl ?? "")
            self.imvAva.kf.setImage(with: url, placeholder: UIImage(named: "default"))
        }
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
        self.pickImage(isLibrary: true)
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
        
        if ( tf1.text == "" || tf2.text == "" ) {
            showToast(content: "Nhập thiếu thông tin")
            return
        }
        
     data.fullName = tf1.text
                 data.phone = tf2.text
                 data.phone2 = tf3.text
                data.email = tf4.text
        
        if(isUpdate) {
            // Update
            update(pData: data)
        } else {
            // Create
            create(pData: data)
        }
    }
    
    func update(pData:Driver) {
        
        showLoading()
        APIClient.updateDriver(data: pData) { result in
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
    
    func create(pData:Driver) {
           
           showLoading()
           APIClient.createDriver(data: pData) { result in
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

extension UpdateDriverViewController : UIImagePickerControllerDelegate {
    
    @objc  func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let cropVC = TOCropViewController.init(croppingStyle: .default, image: image )
        cropVC.delegate = self
        cropVC.aspectRatioPreset = .presetSquare
        
        cropVC.aspectRatioLockEnabled = true
        cropVC.resetAspectRatioEnabled = false
        cropVC.aspectRatioPickerButtonHidden = true
        picker.dismiss(animated: false) {
            self.present(cropVC, animated: false, completion: nil)
        }
    }
}

extension UpdateDriverViewController : TOCropViewControllerDelegate {
    func pickImage(isLibrary: Bool) {
        
        let picker = UIImagePickerController()
        picker.sourceType = isLibrary ?  .photoLibrary : .camera
        picker.allowsEditing = false;
        picker.delegate = self;
        self.present(picker, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        
        imvAva.image = image
//        imvAva.layer.cornerRadius = 40
        
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            
        })
    }
    
    
}
