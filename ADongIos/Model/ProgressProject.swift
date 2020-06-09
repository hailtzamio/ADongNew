//
//  ProgressProject.swift
//  ADongIos
//
//  Created by Cuongvh on 6/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ProgressProject: Codable {
    var id : Int?
    var finishDatetime : String?
    var createdTime : String?
    var updatedTime : String?
    var projectId : Int?
    var projectName : String?
    var workOutlineId : Int?
    var workOutlineName : String?
    var createdById : Int?
    var createdByFullName : String?
    var updatedById : Int?
    var updatedByFullName : String?
    var order : Int?
    var photos : [PhotoProject]?
}

class PhotoProject: Codable {
    let thumbnailUrl: String?
    let fullSizeUrl: String?
}
