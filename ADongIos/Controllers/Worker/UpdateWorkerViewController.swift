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
class UpdateWorkerViewController: BaseViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imvAva: UIImageView!
    @IBOutlet weak var header: NavigationBar!
    var data = Worker()
    var isUpdate = true // if false Create
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
    @IBOutlet weak var tf3: RadiusTextField!
    @IBOutlet weak var tf4: RadiusTextField!
    @IBOutlet weak var tf5: RadiusTextField!
    @IBOutlet weak var tf6: RadiusTextField!
    var avatarData:Data? = nil
    var avatarExtId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        
        if(isUpdate) {
            tf1.text = data.fullName
            tf2.text = data.phone
            tf3.text = data.lineId
            tf4.text = data.address
            tf5.text = data.bankName
            tf6.text = data.bankAccount
            avatarExtId = data.avatarExtId ?? ""
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
        data.lineId = tf3.text
        data.address = tf4.text
        data.bankName = tf5.text
        data.bankAccount = tf6.text
        data.avatarExtId = avatarExtId
        
        if(isUpdate) {
            // Update
            update(pData: data)
        } else {
            // Create
            data.isTeamLeader = false
            create(pData: data)
        }
    }
    
    func update(pData:Worker) {
        
        showLoading()
        APIClient.updateWorker(data: pData) { result in
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
    
    func create(pData:Worker) {
        
        showLoading()
        APIClient.createWorker(data: pData) { result in
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

extension UpdateWorkerViewController : UIImagePickerControllerDelegate {
    
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

extension UpdateWorkerViewController : TOCropViewControllerDelegate {
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
        
        if(imvAva != nil){
            uploadAvatar2(arrImage: image, withblock: {_response in
                
            })
        }
        
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            
        })
    }
    
    func uploadAvatar2(arrImage:UIImage, withblock:@escaping (_ response: AnyObject?)->Void){
        showLoading()
        let url = K.ProductionServer.baseURL + "uploadAvatar"
        
        var headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Accept" : "application/json"]
        headers["Authorization"] = ContentType.token.rawValue
        AF.upload(multipartFormData: { (multipartFormData) in
            
            let randomIntFrom0To10 = Int.random(in: 1..<1000)
            
            guard let imgData = arrImage.pngData() else { return }
            multipartFormData.append(imgData, withName: "image", fileName: "image\(randomIntFrom0To10)", mimeType: "image/jpeg")
            
        },to: url, usingThreshold: UInt64.init(),
          method: .post,
          headers: headers).response{ response in
            self.stopLoading()
            if((response.data != nil)){
                do{
                    if let jsonData = response.data {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        
                        let status = parsedData["status"] as? NSInteger ?? 0
                        
                        if (status == 1){
                            self.avatarExtId = parsedData["data"]?["id"] as! String
                        } else{
                            self.showToast(content: "Không thành công")
                        }
                    }
                } catch{
                    print("error message")
                }
            }else{
                self.showToast(content: "Không thành công")
            }
        }
    }
}
