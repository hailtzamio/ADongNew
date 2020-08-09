//
//  CriteriaMenu.swift
//  ADongIos
//
//  Created by Cuongvh on 7/24/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class MarkSession : Codable  {
    var id : Int?
    var criteriaBundleName : String?
    var point : Double?
    var type : String?
    var createdTime : String?
    var updatedTime : String?
    var projectId : Int?
    var projectName : String?
    var criteriaBundleId : Int?
    var createdById : Int?
    var createdByFullName : String?
    var updatedById : Int?
    var updatedByFullName : String?
    var note : String?
    var details : [MarkSessionDetail]?
}

class MarkSessionDetail : Codable {
    var id : Int?
    var criterionName : String?
    var point : Double?
    var factor : Int?
    var createdTime : String?
    var updatedTime : String?
    var criterionId : Int?
    var markSessionId : Int?
    var markSessionCriteriaBundleName : String?
    var createdById : Int?
    var createdByFullName : String?
    var updatedById : Int?
    var updatedByFullName : String?
}

class Criteria: Codable {
    var id : Int?
    var name : String?
    var key : String?
    var value : String?
    var userFullName : String?
    var updateTime : String?
}

class CriteriaMenu: Codable {

var type : String?
var score : Double?
var key : String?
var value : String?
var description: String?

}
