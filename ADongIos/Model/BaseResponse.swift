//
//  BaseResponse.swift
//  ADongIos
//
//  Created by Cuongvh on 5/23/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class BaseResponse<T: Codable>: Codable {

    var status: Int?
    var code: Int?
    var message: String?
    var data: T?
    var validationErrors: [Error]?

}

class BaseResponseList<T: Codable>: Codable {
    var status: Int?
    var code: Int?
    var message: String?
    var data: [T]?
    var pagination:Pagination?
}

class Pagination:Codable {
    
    var page: Int?
    var size: Int?
    var totalRecords: Int?
    var totalPages: Int?

}
