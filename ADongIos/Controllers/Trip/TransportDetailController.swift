//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TOCropViewController
class TransportDetailController: BaseViewController, UINavigationControllerDelegate  {
    var item:Transport? = nil
    
    
    var itemNames = ["DANH SÁCH VẬT TƯ","THÔNG TIN CHUNG"]
    
    @IBOutlet weak var bt1: UIButton!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var id = 0
    var data = [Information]()
    var data1 = [Information]()
    var status = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        tbView.register(WareHouseViewCell.nib, forCellReuseIdentifier: WareHouseViewCell.identifier)
        
        data.removeAll()
            data1.removeAll()
            getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"

        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        header.isRightButtonHide = true
                header.rightAction = {
                    if let vc = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransportImagesViewController") as? TransportImagesViewController {
                        vc.id = self.id ?? 0
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.pickImage(isLibrary: true)
        }
    }
    
    func pickup() {
        
        if(status == 4 ) {
            self.showLoading()
            APIClient.transportPickup(id: self.id) { result in
                self.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self.goBack()
                    }
                    self.showToast(content: response.message ?? "Thành công")
                    break
                    
                case .failure(let error):
                    self.showToast(content: error.localizedDescription)
                }
            }
        } else if(status == 5) {
            
            self.showLoading()
            APIClient.transportUnload(id: self.id) { result in
                self.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self.goBack()
                    }
                    self.showToast(content: response.message ?? "Thành công")
                    break
                    
                case .failure(let error):
                    self.showToast(content: error.localizedDescription)
                }
            }
            
        }
        
        
    }
    
    func getData() {
        showLoading()
        APIClient.getTransport(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    self.data.append(Information(pKey: "Code",pValue: value.code ?? "---"))
                           self.data.append(Information(pKey: "Ngày dự kiến",pValue: value.plannedDatetime ?? "---"))
                    self.data.append(Information(pKey: "Kho / Xưởng", pValue: value.warehouseName ?? "---"))
                          self.data.append(Information(pKey: "Địa chỉ Kho / Xưởng", pValue: value.warehouseAddress ?? "---"))
                    self.data.append(Information(pKey: "Tên dự án", pValue: value.projectName ?? "---"))
                        self.data.append(Information(pKey: "Địa chỉ dự án", pValue: value.projectAddress ?? "---"))
                    if(value.lines != nil) {
                        value.lines?.forEach({ (t) in
                            let quantity = t.quantity ?? 0
                            let model = Information(pKey: "\(quantity) \(t.productUnit ?? "")" ,pValue: t.productName ?? "---")
                            self.data1.append(model)
                        })
                    }
                    
                    if(value.status != nil) {
                        self.status = value.status ?? 0
                        switch value.status {
                        case 5:
                            self.bt1.setTitle("GIAO HÀNG", for: .normal)
                            break
                        case 3:
                            self.bt1.isHidden = true
                            break
                        default:
                            break
                        }
                        
                    }
                    
                    self.tbView.reloadData()
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        showYesNoPopup(title: "Xác nhận", message: "Đã nhận hàng?")
    }
}

extension TransportDetailController: UITableViewDataSource, UITableViewDelegate {
    
    
    @objc func handleRegister(){
        if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        sectionView.backgroundColor = UIColor.init(hexString: "#ffffff")
        
        let sectionName = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        sectionName.text = itemNames[section]
        sectionName.textColor = UIColor.init(hexString: HexColorApp.orange)
        sectionName.font = UIFont.systemFont(ofSize: 17)
        sectionName.textAlignment = .left
        sectionName.font = UIFont.boldSystemFont(ofSize: 16)
        let uiButton = UIButton(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        uiButton.addTarget(self, action:#selector(handleRegister),
                           for: .touchUpInside)
        sectionView.addSubview(sectionName)
        sectionView.addSubview(uiButton)
        return sectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return data1.count
        case 1:
            return data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch (indexPath.section) {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
            cell.setData(data: data[indexPath.row])
               cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if(indexPath.row == data.count - 1) {
                cell.line.isHidden = true
            }
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
            cell.setData(data: data1[indexPath.row])
                        if(indexPath.row == data1.count - 1) {
                            cell.line.isHidden = true
                        }
               cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            break
        }
        return cell
    }
}

extension TransportDetailController : UIImagePickerControllerDelegate {
    
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

extension TransportDetailController : TOCropViewControllerDelegate {
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
        let url = K.ProductionServer.baseURL + "transportRequest/\(id)/uploadPhoto"
        
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
                            self.pickup()
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
