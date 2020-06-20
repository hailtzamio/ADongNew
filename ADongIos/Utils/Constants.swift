//
//  Constants.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 26/11/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let accessToken = "accessToken"
let number_phone_key = "number_phone_key"
let user_address_key = "user_address_key"
let passwork_key = "passwork_key"
let fullName = "fullName"
let user_role_key = "user_role_key"
let quickly_hold_sim = "quickly_hold_sim"
let copy_ctv_sim_price = "copy_ctv_sim_price"
let error_check_internet = "Không có kết nối mạng"

struct K {
    struct ProductionServer {
        static var baseURL = "http://adong-api-dev.zamio.net/api/"
        static var  ACCESS_TOKEN: String = ""
    }
    
    
}

struct APIParameterKey {
    static let password = "password"
    static let email = "username"
}

struct StoreKey {
    static let accessToken = "accessToken"
    static let emaifullNamel = "username"
}

struct TypeOfWorker {
    static let worker = 0
    static let leader = 1
    static let manager = 2
    static let deputyManager = 3
    static let secretary = 4
            static let suppervisor = 6
        static let keeper = 5
    
    
    static let emaifullNamel = "username"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

struct UserDefaultsKey {
    static let AccessToken = "AccessToken"
    static let UserLogin = "UserLogin"
    static let IndexIntro = "IndexIntro"
    static let SimCategory = "SimCategory"
}

enum ContentType: String {
    case json = "application/json"
    case token = "Bearer eyJ0eXBlIjoiSldUIiwiYWxnIjoiSFM1MTIifQ.eyJzdWIiOiJhZG1pbiIsImF1ZCI6InNpbXBsZS1jbGllbnQiLCJpc3MiOiJTaW1wbGVBUEkiLCJyb2xlcyI6WyJRdeG6o24gbMO9IHbhuq10IHTGsCIsIkvhur8gdG_DoW4iLCJRdeG6o24gbMO9IHbDuW5nIiwiVGjGsCBrw70iLCJUw6BpIHjhur8iLCJRdeG6o24gbMO9IMSR4buZaSB4ZSIsIlRo4bunIGtobyIsIkFkbWluaXN0cmF0b3IiLCLEkOG7mWkgdHLGsOG7n25nIC8gR2nDoW0gc8OhdCJdLCJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4ifQ.pAt8o_PilsZDpep3Snvz-851Hr6Ky5Vv8_O51eCsA7TGZfTCJze7jZECBF5yNJq8rcbccIk0L1XVRLPmHwnVBw"
}

struct Parameter {
    // headers
    static let Accept = "Accept"
    static let ApplicationJson = "application/json"
    static let AccessTokenType = "access-token"
    static let ContentType = "Content-Type"
    static let FormUrlEncoded = "application/x-www-form-urlencoded"
    static let MultiPartFormData = "multipart/form-data"
    
    // params
    static let Name = "name"
    static let UserName = "username"
    static let Email = "email"
    static let Password = "password"
}
