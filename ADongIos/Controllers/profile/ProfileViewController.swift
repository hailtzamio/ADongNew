//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TOCropViewController
import BSImagePicker
import Photos
class ProfileViewController: BaseViewController {
    var id = 0
    var item = Worker()
    var avatarExtId = ""
    @IBOutlet weak var imvAva: UIImageView!
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    
    
    
    var data = [Information]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle()
        yesNoHandle()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    
    @IBAction func changeAvatar(_ sender: Any) {
        
        let alert = UIAlertController(title: "Tùy chọn", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Album", style: .default , handler:{ (UIAlertAction)in
            self.pickImage(isLibrary: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.pickImage(isLibrary: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
                vc.data = self.item
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeWorker(id: self.id) { result in
                self.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self.goBack()
                    }
                    self.showToast(content: response.message ?? "")
                    break
                    
                case .failure(let error):
                    self.showToast(content: error.localizedDescription)
                }
            }
        }
        
    }
    
    func getData() {
        showLoading()
        let imageDf = UIImage(named: "default")
        APIClient.getMyProfile { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    print(value.address)
                    self.item = value
                    self.data.removeAll()
                    self.convertData(value: value)
                    
                    //                    self.lbName.text = value.fullName ?? "---"
                    //                    self.lbPhone.text = value.phone
                    //
                    //                    if(value.isTeamLeader ?? false) {
                    //                        self.lbPosition.text = "Đội trưởng"
                    //                    } else {
                    //                        self.lbPosition.text = "Công nhân"
                    //                    }
                    
                    self.data.append(Information(pKey: "Họ tên",pValue: value.fullName ?? "---"))
                    self.data.append(Information(pKey: "Số điện thoại",pValue: value.phone ?? "---"))
                    self.data.append(Information(pKey: "Email",pValue: value.email ?? "---"))
//                    self.data.append(Information(pKey: "Địa chỉ",pValue: value.address ?? "---"))
                    
                    //                    self.data.append(Information(pKey: "Line ID",pValue: value.lineId ?? "---"))
                    
                    
                    //                    if let status = value.workingStatus {
                    //                        if(status == "working") {
                    //                            self.data.append(Information(pKey: "Trạng thái",pValue: "Đang bận"))
                    //                        } else {
                    //                            self.data.append(Information(pKey: "Trạng thái",pValue: "Đang rảnh"))
                    //                        }
                    //                    } else {
                    //                        self.data.append(Information(pKey: "Trạng thái",pValue: "---"))
                    //                    }
                    
                    
                    //                    self.data.append(Information(pKey: "Đội thi công",pValue: value.teamName ?? "---"))
                    
                    //                    self.data.append(Information(pKey: "Ngân hàng",pValue: value.bankName ?? "---"))
                    
                    
                    //                    self.data.append(Information(pKey: "Số tài khoản",pValue: value.bankAccount ?? "---"))
                    
                    let url = URL(string: value.avatarUrl ?? "")
                    self.imvAva.kf.setImage(with: url, placeholder: imageDf)
                    
                    self.tbView.reloadData()
                    return
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func updateProfile(pData : Worker) {
        showLoading()
        APIClient.updateProfile(data: pData) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
                    self.showToast(content: "Thành công")
                    self.getData()
                    return
                } else {
                    self.showToast(content: response.message ?? "Không thành công")
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
        
    }
    
    private func convertData(value:Worker) {
        if(value.address == "") {
            value.address = nil
        }
        
        if(value.lineId == "") {
            value.lineId = nil
        }
        
        if(value.teamName == "") {
            value.teamName = nil
        }
        
        if(value.bankName == "") {
            value.bankName = nil
        }
        if(value.bankAccount == "") {
            value.bankAccount = nil
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        showYesNoPopup(title: "Xác nhận", message: "Bạn muốn đăng xuất tài khoản này?")
    }
    
    
    @IBAction func remove(_ sender: Any) {
        showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell

        if(data.count > indexPath.row) {
         cell.setData(data: data[indexPath.row])
        }
        return cell
    }
    
    func yesNoHandle() {
        
        okAction = {
            self.preferences.set(nil
                , forKey: accessToken)
            Context.AccessToken = ""
            Switcher.updateRootVC()
            //           One/ignal.deleteTag("user_id")
        }
        
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate {
    
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

extension ProfileViewController : TOCropViewControllerDelegate, UINavigationControllerDelegate {
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
        headers["Authorization"] = Context.AccessToken
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
                            self.item.avatarExtId = parsedData["data"]?["id"] as! String
                            self.updateProfile(pData: self.item)
             
                        } else {
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
