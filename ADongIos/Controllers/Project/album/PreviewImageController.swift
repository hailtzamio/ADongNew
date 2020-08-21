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

class PreviewImageController: BaseViewController {
    
    
    @IBOutlet weak var imv1: UIImageView!
    var isHideRemoveButton = true
    var avatarUrl =  ""
    var id = 0
    var reloadCallback : ((Bool?) -> Void)?
    @IBOutlet weak var btnRemove: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageDf = UIImage(named: "default")
        
        let url = URL(string: avatarUrl ?? "")
        imv1.kf.setImage(with: url, placeholder: imageDf)
        
        print(avatarUrl)
        btnRemove.isHidden = isHideRemoveButton
        
        
        popupHandle()
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
    
    
  
    @IBAction func close(_ sender: Any) {
          navigationController?.popViewController(animated: false)
      }
    
    @IBAction func removeImage(_ sender: Any) {
         showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
    }
}
