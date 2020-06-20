//
//  CheckBoxCustom.swift
//  ADongIos
//
//  Created by Cuongvh on 6/20/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class CheckBoxCustom: UIButton {
    // Images
    let checkedImage = UIImage(named: "correct")! as UIImage
    let uncheckedImage = UIImage(named: "green_dot")! as UIImage

    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
