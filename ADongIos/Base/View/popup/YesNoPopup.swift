//
//  YesNoPopup.swift
//  FastShare
//
//  Created by Tcsytems on 7/6/19.
//  Copyright © 2019 Fullname. All rights reserved.
//

import UIKit
import IQDropDownTextField
import IQKeyboardManagerSwift
import Toaster
class YesNoPopup: PopupView {
    
    var ok: ((Worker) -> ())?
    var cancel: (() -> ())?
    var close: (() -> ())?
    
    
    @IBOutlet weak var tf1: RadiusTextField!
    
    @IBOutlet weak var tf2: RadiusTextField!
    
    @IBOutlet weak var tf3: RadiusTextField!
    @IBOutlet weak var lbTitle: UILabel!
    
    
    
    
    override func awakeFromNib() {
        
        
    }
    
    class func instanceFromNib(title:String) -> YesNoPopup {
        let detailView = UINib(nibName: "YesNoPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YesNoPopup
        detailView.lbTitle.text = title
        
        
        
        
        detailView.animationType =  AnimationType.alpha
        detailView.popupFrame = CGRect.init(x: 20, y: (SCREEN_HEIGHT - 300)/2 , width: SCREEN_WIDTH - 40, height: 300)
        detailView.layer.cornerRadius = 5
        detailView.clipsToBounds = true
        
        
//        if(data.typeOfManager == 1) {
//
//            if(data.investorContacts != nil && data.investorContacts?.manager != nil) {
//                detailView.tf1.text = data.investorContacts?.manager?.name ?? ""
//                        detailView.tf2.text = data.investorContacts?.manager?.phone ?? ""
//                    detailView.tf3.text = data.investorContacts?.manager?.email ?? ""
//            }
//
//
//        } else {
//
//
//                 if(data.investorContacts != nil && data.investorContacts?.deputyManager != nil) {
//                     detailView.tf1.text = data.investorContacts?.deputyManager?.name ?? ""
//                    detailView.tf2.text = data.investorContacts?.deputyManager?.phone ?? ""
//                                   detailView.tf3.text = data.investorContacts?.deputyManager?.email ?? ""
//                 }
//        }
        
        
        return detailView
        
    }
    
    
    @IBAction func btnOk(_ sender: Any) {
        
        
        if(tf1.text == "" || tf2.text == "") {
            Toast(text: "Nhập thiếu dữ liệu", duration: Delay.short).show()
            return
        }
        
        self.hide()
        
        
        var worker = Worker()
        worker.fullName = tf1.text
        if(tf3.text != "") {
            worker.email = tf3.text
        }
        worker.phone = tf2.text
        if let action = ok {
            action(worker)
        }
        
        
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        self.hide()
        if let action = cancel {
            action()
        }
    }
    
    
    @IBAction func btnClose(_ sender: Any) {
        self.hide()
    }
}
