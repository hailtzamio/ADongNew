//
//  ViewController.swift
//  PageMenuDemoStoryboard
//
//  Created by Niklas Fahl on 12/19/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TOCropViewController
import BSImagePicker
import Photos
class DetailProjectViewController: BaseViewController {
    
    var pageMenu : CAPSPageMenu?
    var id = 0
    var ptitle = ""
    var isJustChangeWorkoutImage = false
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var header: NavigationBar!
    var project = Project()
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var typeOfUploadingImage = 1 // 1. CheckinOut 2. WorkOutline
    var workOutlineId = 0
    let controller2 = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProgessViewController") as? ProgessViewController
    override func viewDidLoad() {
        // MARK: - UI Setup
        
        self.tabBarController?.tabBar.isHidden = true
        
        header.title = ptitle
        header.isRightButtonHide = true
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
        
        
        self.title = "PAGE MENU"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItem.Style.done, target: self, action: #selector(DetailProjectViewController.didTapGoToLeft))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItem.Style.done, target: self, action: #selector(DetailProjectViewController.didTapGoToRight))
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        if(project.teamType == "ADONG") {
            let controller1 = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckinoutViewController") as? CheckinoutViewController
            controller1!.title = "Chấm Công"
            controller1?.id = id
            controller1?.callback = {(it) in
                self.typeOfUploadingImage = 1
                self.showTakePhotoPopup()
            }
            controllerArray.append(controller1!)
        }
        
        controller2!.title = "Tiến Độ"
        controller2?.id = id
        controller2?.callback = {(it) in
            if(it != 0) {
                self.typeOfUploadingImage = 2
                self.workOutlineId = it ?? 0
                self.showTakePhotoPopup()
            } else  {
                self.typeOfUploadingImage = 3
                self.ChooseImagesToFinishProject()
            }
        }
        
     
        
        controller2?.callbackPreviewImage = {(url, id) in
            if(id == 0) {
             self.isJustChangeWorkoutImage = true
            } else {
                self.goToImagePreview(url: url ?? "",id : id ?? 0)
            }
        }
        controllerArray.append(controller2!)
        
        let controller3 = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "InformationListViewController") as? InformationListViewController
        controller3!.title = "Thông Tin"
        controller3?.id = id
        controller3?.project = project
        controller3?.callback = {(data) in
            switch data?.title {
            case ProjectTitle.title1:
                self.goToBaseInformation()
                break
            case ProjectTitle.title2:
                self.goToProjectBidding()
                break
            case ProjectTitle.title3:
                self.goToProductRequirement()
                break
            case ProjectTitle.title4:
                self.goToRating()
                break
            case ProjectTitle.title5:
                self.goToChooseWorker()
                break
            case ProjectTitle.title6:
                self.goToCheckinOutList()
                break
            case ProjectTitle.title7:
                self.goToFiles()
            case ProjectTitle.title8:
                //                self.pickImage(isLibrary: true)
                break
            case ProjectTitle.title9:
                self.goToAlbum()
                case ProjectTitle.title10:
                              self.goToLog()
                
                break
            default:
                break
            }
            
        }
        controllerArray.append(controller3!)
        
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.init(hexString: "#4c4c4c")),
            .viewBackgroundColor(UIColor.init(hexString: "#4c4c4c")),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 17.0)!),
            .menuHeight(40.0),
            //                  .menuItemWidth(90.0),
            .centerMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 70.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.contentView.addSubview(pageMenu!.view)
        self.pageMenu!.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        //                self.addChild(pageMenu!)
        //                self.view.addSubview(pageMenu!.view)
        
        //        pageMenu!.didMove(toParent: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @objc func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    @objc func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    // MARK: - Container View Controller
    
    //COULD NOT RESOLVE
    //	override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
    //		return true
    //	}
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
}

extension DetailProjectViewController {
    
    
    func goToBaseInformation() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BaseInformationController") as? BaseInformationController {
            vc.id = id
            vc.notificationType = "Show"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToProductRequirement() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductRequirementViewController") as? ProductRequirementViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func goToProjectBidding() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BiddingListViewController") as? BiddingListViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToChooseWorker() {
        if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
            vc.isToChooseWorker = true
            vc.isAddWorkerToProject = true
            vc.projectId = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToRating() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "RatingListViewController") as? RatingListViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToImagePreview(url : String, id : Int) {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "PreviewImageController") as? PreviewImageController {
            vc.avatarUrl = url
            vc.isHideRemoveButton = false
            vc.id = id
            vc.reloadCallback = {(isReload) in
                self.controller2?.getData()
            }
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func goToCheckinOutList() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckinOutListViewController") as? CheckinOutListViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToLog() {
         if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogsListViewController") as? LogsListViewController {
             vc.id = id
             navigationController?.pushViewController(vc, animated: true)
         }
     }
    
    func goToAlbum() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProjectImagesViewController") as? ProjectImagesViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToFiles() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileListViewController") as? FileListViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DetailProjectViewController : TOCropViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func pickImage(isLibrary: Bool) {
        
        let picker = UIImagePickerController()
        picker.sourceType = isLibrary ?  .photoLibrary : .camera
        picker.allowsEditing = false;
        picker.delegate = self;
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        
        if(typeOfUploadingImage == 1) {
            uploadToCheckOutInWorker(arrImage: image, withblock: {_response in
                
            })
        } else if(typeOfUploadingImage == 2) {
            finishWorkOutlineImage(arrImage: image, withblock: {_response in
                
            })
        } else {
            ChooseImagesToFinishProject()
        }
        
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            
        })
    }
    
    @objc  func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let cropVC = TOCropViewController.init(croppingStyle: .default, image: image )
        cropVC.delegate = self
        cropVC.aspectRatioPreset = .presetOriginal
        
        cropVC.aspectRatioLockEnabled = true
        cropVC.resetAspectRatioEnabled = false
        cropVC.aspectRatioPickerButtonHidden = true
        picker.dismiss(animated: false) {
            self.present(cropVC, animated: false, completion: nil)
        }
    }
    
    func finishWorkOutline() {
        
        if(workOutlineId == 0) {
            return
        }
        
        self.showLoading()
        APIClient.finishWorkOutline(id : self.workOutlineId) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                self.controller2?.getData()
                self.showToast(content: response.message ?? "Thành cônggg")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func finishWorkOutlineImage(arrImage:UIImage, withblock:@escaping (_ response: AnyObject?)->Void){
        showLoading()
        
        let url = K.ProductionServer.baseURL + "projectWorkOutline/\(self.workOutlineId)/uploadCompletionPhoto"
        
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
                            if(!self.isJustChangeWorkoutImage) {
                                self.finishWorkOutline()
                            } else {
                                self.controller2?.getData()
                            }
                            
                            self.isJustChangeWorkoutImage = false
                            
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
    
    func uploadProjectCompletionPhoto(arrImage:UIImage, withblock:@escaping (_ response: AnyObject?)->Void){
        showLoading()
        
        let url = K.ProductionServer.baseURL + "project/\(id)/uploadProjectCompletionPhoto"
        
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
    
    
    func ChooseImagesToFinishProject() {
        //        self.PhotoArray.removeAll()
        let imagePicker = ImagePickerController()
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            // User finished selection assets.
            //
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
            }
            self.getAllImages()
            print("ahihi \(self.PhotoArray.count)")
            self.finishProject(arrImage: self.PhotoArray)
        })
    }
    
    func getAllImages() -> Void {
        
        print("get all images method called here")
        if SelectedAssets.count != 0{
            for i in 0..<SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.PhotoArray.append(thumbnail)
            }
        }
    }
    
    func finishProject(arrImage:[UIImage]) {
        
        showLoading()
        APIClient.finishProject(id : id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.status == 1) {
                    self.showToast(content: response.message ?? "Thành công")
                    self.controller2?.getProject()
                    arrImage.forEach { (image) in
                        self.uploadProjectCompletionPhoto(arrImage: image, withblock: {_response in
                            
                        })
                    }
                    
                    
                } else {
                    //                        self.PhotoArray.removeAll()
                    self.showToast(content: response.message ?? "Có lỗi")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadToCheckOutInWorker(arrImage:UIImage, withblock:@escaping (_ response: AnyObject?)->Void){
        showLoading()
        let url = K.ProductionServer.baseURL + "project/\(id)/uploadCheckinPhoto"
        
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
                            self.showToast(content: "Thành công")
                            
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
    
    func showTakePhotoPopup() {
        
        let alert = UIAlertController(title: "Tùy chọn", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Album", style: .default , handler:{ (UIAlertAction)in
            self.pickImage(isLibrary: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.pickImage(isLibrary: false)
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


