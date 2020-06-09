//
//  TitleModel.swift
//  ADongIos
//
//  Created by Cuongvh on 6/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class TitleModel : Codable {
    var title: String?
    var imagePath: String?
    
    init(pTitle:String, pImagePath: String) {
           title = pTitle
           imagePath = pImagePath
    }
}
