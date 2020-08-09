//
//  PreviewImageController.swift
//  ADongIos
//
//  Created by Cuongvh on 7/25/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher


class PreviewImageController: UIViewController {
    
    
    @IBOutlet weak var imv1: UIImageView!
    var avatarUrl =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageDf = UIImage(named: "default")
        
        avatarUrl = avatarUrl + "&accessToken=" + Context.AccessToken.substring(from: 6)
//        avatarUrl = "https://znews-photo.zadn.vn/w660/Uploaded/mdf_reovdl/2020_07_25/BN_1.jpg"
        let url = URL(string: avatarUrl ?? "")
        
        print(avatarUrl)
        
        imv1.kf.setImage(with: url, placeholder: imageDf)
        
//        let modifier = AnyModifier { request in
//            var r = request
//            // replace "Access-Token" with the field name you need, it's just an example
//            r.setValue(Context.AccessToken, forHTTPHeaderField: "Authorization")
//            return r
//        }

//        imv1.kf.setImage(with: url, options: [.requestModifier(modifier)]) { (image, error, type, url) in
//            if error == nil && image != nil {
//                // here the downloaded image is cached, now you need to set it to the imageView
//                DispatchQueue.main.async {
//                    self.imv1.image = image
//                }
//            } else {
//                // handle the failure
//                print(error)
//            }
//        }
        
        
//        let modifier = AnyModifier { request in
//            var r = request
//            r.setValue(Context.AccessToken, forHTTPHeaderField: "accessToken")
//            return r
//        }
//        imv1.kf.setImage(with: url, placeholder: imageDf, options: [.requestModifier(modifier)])
        
    }
    
    
  
    @IBAction func close(_ sender: Any) {
          navigationController?.popViewController(animated: false)
      }
    
}
