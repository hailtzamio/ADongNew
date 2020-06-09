//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import TOCropViewController
import Alamofire
class CheckinoutViewController: BaseViewController, UISearchBarDelegate, LoadMoreControlDelegate, UINavigationControllerDelegate  {
    
    var data = [Worker]()
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var page = 0
    var totalPages = 0
    var id = 0
    var currentData = Worker()
    
    var loadMoreControl: LoadMoreControl!
    @IBOutlet weak var tbView: UITableView!
    // For Adding To Team
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupHandle()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CommonTableViewCell.nib, forCellReuseIdentifier: CommonTableViewCell.identifier)
        
        loadMoreControl = LoadMoreControl(scrollView: tbView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreControl.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 0
        data.removeAll()
        getData()
    }
    
    func getData() {
        showLoading()
        APIClient.getProjectWorkers(id : id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data = response.data!
                    self.tbView.reloadData()
                    if(response.pagination != nil && response.pagination?.totalPages != nil) {
                        self.totalPages = response.pagination?.totalPages as! Int
                        self.page = self.page + 1
                    }
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        print(" \(page) \(totalPages)")
        if page < totalPages {
            getData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
            self?.loadMoreControl.stop()
        }
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        
    }
    
    @IBOutlet weak var takePhoto: UIImageView!
    
    @IBAction func takePhoto(_ sender: Any) {
        pickImage(isLibrary: true)
    }
    
}

extension CheckinoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.identifier, for: indexPath) as! CommonTableViewCell
        cell.setDataWorker(data: data[indexPath.row])
        cell.imvCheck.isHidden = true
        cell.imvStatus.isHidden = false
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentData = data[indexPath.row]
        showYesNoPopup(title: "Xác nhận", message: "Điểm danh?")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreControl.didScroll()
    }
}

extension CheckinoutViewController {
    
    func popupHandle() {
        
        
        
        
        
        okAction = {
            
            var ints = [Int]()
            ints.append(self.currentData.id!)
            
            var rq = CheckInOut()
            rq.projectId = self.id
            rq.workerIds = ints
            
            
            
            if(self.currentData.workingStatus == "idle") {
                self.checkin(data: rq)
            } else {
                self.checkout(data: rq)
            }
            
        }
        
        noAction = {
            
        }
    }
    
    func checkin(data: CheckInOut) {
        self.showLoading()
        APIClient.checkin(data: data) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                if (response.status == 1) {
                   self.getData()
                }
                self.showToast(content: response.message ?? "Thành công")
                break
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func checkout(data: CheckInOut) {
        self.showLoading()
        APIClient.checkout(data: data) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                if (response.status == 1) {
                    self.getData()
                }
                self.showToast(content: response.message ?? "Thành công")
                break
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
}

extension CheckinoutViewController : TOCropViewControllerDelegate {
    func pickImage(isLibrary: Bool) {
        
        let picker = UIImagePickerController()
        picker.sourceType = isLibrary ?  .photoLibrary : .camera
        picker.allowsEditing = false
        picker.delegate = self
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
        let url = K.ProductionServer.baseURL + "project/\(id)/uploadCheckinPhoto"
        
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
}

extension CheckinoutViewController : UIImagePickerControllerDelegate {
    
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


