//
//  Category.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 26/11/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Foundation

struct Category: Codable {
    let id: Int
    let brand: String
    let driverId: Int?
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case id
        case brand
        case driverId = "driverId"
    }
}
