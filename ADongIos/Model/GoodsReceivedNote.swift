//
//  GoodsReceivedNote.swift
//  ADongIos
//
//  Created by Cuongvh on 6/12/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class GoodsReceivedNote : Codable {
    var id : Int?
    var code : String?
    var deliveredBy : String?
    var ref : String?
    var note : String?
    var status : String?
    var createdTime : String?
    var updatedTime : String?
    var warehouseId : Int?
    var warehouseName : String?
    var createdById : Int?
    var createdByFullName : String?
    var updatedById : Int?
    var updatedByFullName : String?
    var confirmationDate : String?
    
    
    
    
    var lines : [Product]?
}


