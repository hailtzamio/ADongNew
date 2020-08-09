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
import BSImagePicker
import Photos
class ProgessViewController: BaseViewController, UINavigationControllerDelegate {
    
    var data = [ProgressProject]()
    var currentWorkOutline = ProgressProject()
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var callback : ((Int?) -> Void)?
     var callbackPreviewImage : ((String?) -> Void)?
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var btnFinish: UIButton!
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        popupHandle()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(ProjectProgressViewCell.nib, forCellReuseIdentifier: ProjectProgressViewCell.identifier)
        
        getData()
        getProject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func finishProject(_ sender: Any) {
        //        ChooseImagesToFinishProject()
        callback!(0)
    }
    func popupHandle() {
        //        okAction = {
        //            self.showTakePhotoPopup()
        //            //            self.pickImage(isLibrary: false)
        //        }
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
    
    func getProject() {
        
        APIClient.getProject(id : id) { result in
            
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    let project = response.data
                    if(project?.status == "DONE") {
                        self.btnFinish.setTitle("", for: .normal)
                        self.btnFinish.isEnabled = false
                        self.btnFinish.tintColor = UIColor.init(hexString: HexColorApp.green)
                        self.btnFinish.backgroundColor = UIColor.init(hexString: HexColorApp.white)
                    }
                    
                }
                
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
                    
                    var isHideTvOk = false
                    self.data.forEach { (value) in
                        if(value.finishDatetime == nil) {
                            isHideTvOk = true
                        }
                    }
                    
                    self.btnFinish.isHidden = isHideTvOk
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //    func showTakePhotoPopup() {
    //
    //        let alert = UIAlertController(title: "Tùy chọn", message: "", preferredStyle: .actionSheet)
    //
    //        alert.addAction(UIAlertAction(title: "Album", style: .default , handler:{ (UIAlertAction)in
    //            self.pickImage(isLibrary: true)
    //        }))
    //
    //        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
    //            self.pickImage(isLibrary: false)
    //        }))
    //
    //        //        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
    //        //            print("User click Delete button")
    //        //        }))
    //
    //        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
    //            print("User click Dismiss button")
    //        }))
    //
    //        self.present(alert, animated: true, completion: {
    //            print("completion block")
    //        })
    //    }
}



extension ProgessViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectProgressViewCell.identifier, for: indexPath) as! ProjectProgressViewCell
        cell.setDataWorkOutline(data: data[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.row].finishDatetime == nil {
            callback!(data[indexPath.row].id)
            //            currentWorkOutline = data[indexPath.row]
            //            showYesNoPopup(title: "Xác nhận", message: "Hạng mục đã hoàn thành?")
        } else {
            // view Image
            
            if(data[indexPath.row].photos?.count ?? 0 > 0) {
                callbackPreviewImage!(data[indexPath.row].photos?[0].thumbnailUrl ?? "")
            }
            
        }
        
    }
    
    
    
}

//extension ProgessViewController : UIImagePickerControllerDelegate {
//
//    @objc  func imagePickerController(_ picker: UIImagePickerController,
//                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = info[.originalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//
//        let cropVC = TOCropViewController.init(croppingStyle: .default, image: image )
//        cropVC.delegate = self
//        cropVC.aspectRatioPreset = .presetSquare
//
//        cropVC.aspectRatioLockEnabled = true
//        cropVC.resetAspectRatioEnabled = false
//        cropVC.aspectRatioPickerButtonHidden = true
//        picker.dismiss(animated: false) {
//            self.present(cropVC, animated: false, completion: nil)
//        }
//    }
//}

//extension ProgessViewController : TOCropViewControllerDelegate {
//    func pickImage(isLibrary: Bool) {
//
//        let picker = UIImagePickerController()
//        picker.sourceType = isLibrary ?  .photoLibrary : .camera
//        picker.allowsEditing = false;
//        picker.delegate = self;
//        self.present(picker, animated: true, completion: nil)
//    }
//
//
//    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
//
//
//
//
//        uploadAvatar2(arrImage: image, withblock: {_response in
//
//        })
//
//
//        cropViewController.dismiss(animated: true, completion: nil)
//
//    }
//
//    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
//        cropViewController.dismiss(animated: true, completion: {
//
//        })
//    }
//
//    func uploadAvatar2(arrImage:UIImage, withblock:@escaping (_ response: AnyObject?)->Void){
//        showLoading()
//
//        let id = currentWorkOutline.id ?? 0
//        let url = K.ProductionServer.baseURL + "projectWorkOutline/\(id)/uploadCompletionPhoto"
//
//        var headers: HTTPHeaders
//        headers = ["Content-type": "multipart/form-data",
//                   "Accept" : "application/json"]
//        headers["Authorization"] = ContentType.token.rawValue
//        AF.upload(multipartFormData: { (multipartFormData) in
//
//            let randomIntFrom0To10 = Int.random(in: 1..<1000)
//
//            guard let imgData = arrImage.pngData() else { return }
//            multipartFormData.append(imgData, withName: "image", fileName: "image\(randomIntFrom0To10)", mimeType: "image/jpeg")
//
//        },to: url, usingThreshold: UInt64.init(),
//          method: .post,
//          headers: headers).response{ response in
//            self.stopLoading()
//            if((response.data != nil)){
//                do{
//                    if let jsonData = response.data {
//                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
//                        print(parsedData)
//
//                        let status = parsedData["status"] as? NSInteger ?? 0
//
//                        if (status == 1){
//                            self.finishWorkOutline()
//                        } else{
//                            self.showToast(content: "Không thành công")
//                        }
//                    }
//                } catch{
//                    print("error message")
//                }
//            }else{
//                self.showToast(content: "Không thành công")
//            }
//        }
//    }
//
//
//    func uploadProjectCompletionPhoto(arrImage:UIImage, withblock:@escaping (_ response: AnyObject?)->Void){
//        showLoading()
//
//        let url = K.ProductionServer.baseURL + "project/\(id)/uploadProjectCompletionPhoto"
//
//        var headers: HTTPHeaders
//        headers = ["Content-type": "multipart/form-data",
//                   "Accept" : "application/json"]
//        headers["Authorization"] = ContentType.token.rawValue
//        AF.upload(multipartFormData: { (multipartFormData) in
//
//            let randomIntFrom0To10 = Int.random(in: 1..<1000)
//
//            guard let imgData = arrImage.pngData() else { return }
//            multipartFormData.append(imgData, withName: "image", fileName: "image\(randomIntFrom0To10)", mimeType: "image/jpeg")
//
//        },to: url, usingThreshold: UInt64.init(),
//          method: .post,
//          headers: headers).response{ response in
//            self.stopLoading()
//            if((response.data != nil)){
//                do{
//                    if let jsonData = response.data {
//                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
//                        print(parsedData)
//
//                        let status = parsedData["status"] as? NSInteger ?? 0
//
//                        if (status == 1){
//
//                        } else{
//                            self.showToast(content: "Không thành công")
//                        }
//                    }
//                } catch{
//                    print("error message")
//                }
//            }else{
//                self.showToast(content: "Không thành công")
//            }
//        }
//    }
//
//
//    func ChooseImagesToFinishProject() {
//        self.PhotoArray.removeAll()
//        let imagePicker = ImagePickerController()
//
//        presentImagePicker(imagePicker, select: { (asset) in
//            // User selected an asset. Do something with it. Perhaps begin processing/upload?
//        }, deselect: { (asset) in
//            // User deselected an asset. Cancel whatever you did when asset was selected.
//        }, cancel: { (assets) in
//            // User canceled selection.
//        }, finish: { (assets) in
//            // User finished selection assets.
//
//            for i in 0..<assets.count
//            {
//                self.SelectedAssets.append(assets[i])
//            }
//              self.getAllImages()
//            print("ahihi \(self.PhotoArray.count)")
//            self.finishProject(arrImage: self.PhotoArray)
//        })
//    }
//
//    func getAllImages() -> Void {
//
//         print("get all images method called here")
//            if SelectedAssets.count != 0{
//                for i in 0..<SelectedAssets.count{
//                    let manager = PHImageManager.default()
//                    let option = PHImageRequestOptions()
//                    var thumbnail = UIImage()
//                    option.isSynchronous = true
//                    manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
//                        thumbnail = result!
//                    })
//                    self.PhotoArray.append(thumbnail)
//                }
//            }
//    }
//
//    func finishProject(arrImage:[UIImage]) {
//
//        showLoading()
//             APIClient.finishProject(id : id) { result in
//                 self.stopLoading()
//                 switch result {
//                 case .success(let response):
//
//                     if(response.status == 1) {
//                        self.getProject()
//
//                        arrImage.forEach { (image) in
//                            self.uploadProjectCompletionPhoto(arrImage: image, withblock: {_response in
//
//                            })
//                        }
//
//
//                     } else {
//                        self.PhotoArray.removeAll()
//                        self.showToast(content: response.message ?? "Có lỗi")
//                    }
//
//                 case .failure(let error):
//                     print(error.localizedDescription)
//                 }
//             }
//    }
//}
