//
//  Notification.swift
//  ADongIos
//
//  Created by Cuongvh on 6/30/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class NotificationOb: Codable {
    var id : Int?
    var objectId : Int?
    var objectType : String?
    var type : String?
    var title : String?
    var userFullName : String?
    var content : String?
    var notSeenCount: Int?
    var seen:Bool?
}
