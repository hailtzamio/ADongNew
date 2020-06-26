//
//  CreateProductReq.swift
//  ADongIos
//
//  Created by Cuongvh on 6/26/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class CreateProductReq: Codable {
    var projectId : Int?
    var note : String?
    var expectedDatetime : String?
    var linesAddNew : [Product]?
}
