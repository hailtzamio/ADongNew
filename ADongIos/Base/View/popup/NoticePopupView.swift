//
//  NoticePopupView.swift
//  QClub
//
//  Created by TuanNM on 10/16/17.
//  Copyright © 2017 Dream. All rights reserved.
//

import UIKit

class NoticePopupView: UIViewController {
    
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var containerView: UIView!
     var hideDialog: (() -> ())?
//    @IBOutlet weak var alert1Lb: UILabel!
//    @IBOutlet weak var alert2Lb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        containerView.layer.cornerRadius = 0
//            containerView.clipsToBounds = true
        
//        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.closeAction))
//        blueView.isUserInteractionEnabled = true
//        blueView.addGestureRecognizer(tapGes)
        
    }

    @objc func closeAction() {
        self.removeFromParent()
        self.view.removeFromSuperview()
        if let hideDialog = self.hideDialog {
            hideDialog()
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
        if let hideDialog = self.hideDialog {
            hideDialog()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
