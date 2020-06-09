//
//  ProgessViewController.swift
//  ADongIos
//
//  Created by Cuongvh on 6/8/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TOCropViewController
class ProgessViewController: BaseViewController, UINavigationControllerDelegate {
    
    var data = [ProgressProject]()
    var currentWorkOutline = ProgressProject()
    @IBOutlet weak var tbView: UITableView!
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        popupHandle()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(ProjectProgressViewCell.nib, forCellReuseIdentifier: ProjectProgressViewCell.identifier)
        
          getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
    }
    
    func popupHandle() {
        okAction = {
              self.pickImage(isLibrary: false)
        }
    }
    
    func finishWorkOutline() {
        
        if(currentWorkOutline.id == nil) {
            return
        }
        
        self.showLoading()
        APIClient.finishWorkOutline(id : self.currentWorkOutline.id!) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                self.data.removeAll()
                self.getData()
                self.showToast(content: response.message ?? "Thành công")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getData() {
        showLoading()
        APIClient.getProjectWokerOutline(id : id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data = response.data!
                    self.tbView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



extension ProgessViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectProgressViewCell.identifier, for: indexPath) as! ProjectProgressViewCell
        cell.setDataWorkOutline(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.row].finishDatetime == nil {
            currentWorkOutline = data[indexPath.row]
            showYesNoPopup(title: "Xác nhận", message: "Hạng mục đã hoàn thành?")
        } else {
            // view Image
        }
        
    }
    
    
    
}

extension ProgessViewController : UIImagePickerControllerDelegate {
    
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

extension ProgessViewController : TOCropViewControllerDelegate {
    func pickImage(isLibrary: Bool) {
        
        let picker = UIImagePickerController()
        picker.sourceType = isLibrary ?  .photoLibrary : .camera
        picker.allowsEditing = false;
        picker.delegate = self;
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        
        
        
        uploadAvatar2(arrImage: image, withblock: {_response in
            
        })
        
        
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            
        })
    }
    
    func uploadAvatar2(arrImage:UIImage, withblock:@escaping (_ response: AnyObject?)->Void){
        showLoading()
        
        let id = currentWorkOutline.id ?? 0
        let url = K.ProductionServer.baseURL + "projectWorkOutline/\(id)/uploadCompletionPhoto"
        
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
                            self.finishWorkOutline()
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
