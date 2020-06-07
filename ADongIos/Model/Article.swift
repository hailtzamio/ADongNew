//
//  Article.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 26/11/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Foundation

struct Article : Codable{
    let status: Int?
    let message: String?
    let data: [Category]?
}
