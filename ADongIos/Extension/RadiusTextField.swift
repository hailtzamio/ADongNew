//
//  RadiusTextField.swift
//  FastShare
//
//  Created by Tcsytems on 4/27/19.
//  Copyright © 2019 Fullname. All rights reserved.
//

import UIKit

class RadiusTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(hexString: "#C8C8C8").cgColor
        backgroundColor = UIColor(hexString: "#FAFAFA")
        addPadding(.left(5.0))
    }
}



