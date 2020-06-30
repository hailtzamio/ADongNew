//
//  GoodsReceivedNote.swift
//  ADongIos
//
//  Created by Cuongvh on 6/12/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class GoodsIssue : Codable {
    var id : Int?
    var code : String?
    var deliveredBy : String?
    var ref : String?
    var note : String?
    var status : Int?
    var createdTime : String?
    var updatedTime : String?
    var warehouseId : Int?
    var warehouseName : String?
    var createdById : Int?
    var createdByFullName : String?
    var updatedById : Int?
    var updatedByFullName : String?
    var confirmationDate : String?
    
    var projectName : String?
    var expectedDatetime : String?
    
    var plannedDatetime : String?
    
    var productReqCode : String?
    var transportReqCode : String?
    var projectAddress : String?
    var productReqId : Int?
    var projectId : Int?
    

    var lines : [Product]?
}


