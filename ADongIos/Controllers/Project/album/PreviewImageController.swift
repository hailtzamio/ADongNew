//
//  PreviewImageController.swift
//  ADongIos
//
//  Created by Cuongvh on 7/25/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import Alamofire

class PreviewImageController: BaseViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var header: NavigationBar!
    @IBOutlet weak var imv1: UIImageView!
    var isHideRemoveButton = true
    var avatarUrl =  ""
    var id = 0
    var reloadCallback : ((Bool?) -> Void)?
    @IBOutlet weak var btnRemove: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageDf = UIImage(named: "default")
        imv1.isUserInteractionEnabled = true
        let url = URL(string: avatarUrl ?? "")
        imv1.kf.setImage(with: url, placeholder: imageDf)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        print(avatarUrl)
        btnRemove.isHidden = isHideRemoveButton
        setupHeader(imagestring: avatarUrl)
        popupHandle()
        
        
        
    }
    
    func setupHeader(imagestring: String) {
        header.title = "Album"
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let url = URL(string: imagestring),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.showToast(content: "Tải ảnh thành công")
            }
        }
        
        header.changeToDownLoadIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeWorkOutlineImage(id: self.id) { result in
                self.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self.goBack()
                        self.reloadCallback!(true)
                    }
                    self.showToast(content: response.message ?? "")
                    break
                    
                case .failure(let error):
                    self.showToast(content: error.localizedDescription)
                }
            }
            
        }
        
    }
    
    @IBAction func removeImage(_ sender: Any) {
        showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imv1
    }
}
