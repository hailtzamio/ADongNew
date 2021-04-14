//
//  Main1HistoryPopup.swift
//  QClub
//
//  Created by SMR on 10/13/17.
//  Copyright © 2017 Dream. All rights reserved.
//

import UIKit

/*
 Page 44 in StoryBoard
 */

class UpdateProductPopup: PopupView {

   
    @IBOutlet weak var lbHeart: UILabel!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfNote: UITextField!
    
    var actionOK : (() -> ())?
    var newText : (( _ text: String?,  _ type: String?)->())?
    
    @IBAction func confirm(_ sender: Any) {
        hide()
        newText?(tfNote.text, tfNumber.text)
    }
    class func instanceFromNib(product: Product) -> UpdateProductPopup {
        let joinView = UINib(nibName: "UpdateProductPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UpdateProductPopup
//        joinView.popupFrame = CGRect.init(x: 0, y: (SCREEN_HEIGHT - CGFloat(245)), width: SCREEN_WIDTH, height: CGFloat(245))
        let productCount = product.quantity
        joinView.tfNumber.text = "\(productCount ?? 0.0)"
        joinView.tfNote.text = product.note ?? ""
        joinView.popupFrame = CGRect.init(x: 20, y: (SCREEN_HEIGHT - 250)/2 , width: SCREEN_WIDTH - 40, height: 250)
        joinView.isEnableTouchOutsideToDissmiss = true
        joinView.animationType = .upDown
        return joinView
    }
}
