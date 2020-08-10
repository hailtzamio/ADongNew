//
//  LinesAddNew.swift
//  ADongIos
//
//  Created by Cuongvh on 7/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

struct LinesAddNew {

    let productId: Int
    let quantity: Int
     let note: String
    var linesAddNew: [String: Any] {
        return ["productId": productId,
                "quantity": quantity, "note" : note]
    }
    var nsDictionary: NSDictionary {
        return linesAddNew as NSDictionary
    }

}
