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
        
        class UpdateProductViewController: BaseViewController, UINavigationControllerDelegate {
            
            @IBOutlet weak var header: NavigationBar!
            var data:Product? = nil
            var isUpdate = true // if false Create
            @IBOutlet weak var tf1: RadiusTextField!
            @IBOutlet weak var tf2: RadiusTextField!
            @IBOutlet weak var tf3: RadiusTextField!
            @IBOutlet weak var tf4: RadiusTextField!
            @IBOutlet weak var imvAva: UIImageView!
            var productType = ""
            var thumbnailExtId = ""
            var thumbnailUrl = ""
            override func viewDidLoad() {
                super.viewDidLoad()
                hideKeyboardWhenTappedAround()
                setupHeader()
                
                if(data != nil) {
                    tf1.text = data?.name
                    tf2.text = data?.code
                    tf3.text = data?.unit
                    thumbnailUrl = data?.thumbnailUrl ?? ""
                    let url = URL(string: thumbnailUrl)
                    imvAva.kf.setImage(with: url, placeholder: UIImage(named: "default"))
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
            
        
            @IBAction func chooseImage(_ sender: Any) {
                self.pickImage(isLibrary: true)
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
                dataRq.thumbnailExtId = thumbnailExtId
                
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
        
        
        extension UpdateProductViewController : UIImagePickerControllerDelegate {
            
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

        extension UpdateProductViewController : TOCropViewControllerDelegate {
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
                                    self.thumbnailExtId = parsedData["data"]?["id"] as! String
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
