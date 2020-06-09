//
//  Trip.swift
//  ADongIos
//
//  Created by Cuongvh on 6/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class Trip: Codable {
var id : Int?
var name : String?
var code : String?
var status : Int?
var plannedDatetime : String?
var createdById : Int?
var createdByFullName : String?
var updatedById : Int?
var updatedByFullName : String?
var createdTime : String?
var updatedTime : String?
var lorryId : Int?
var lorryPlateNumber : String?
var driverId : Int?
var driverFullName : String?
var driverPhone : String?
var note : String?
var transportRequests : [Transport]?

}
