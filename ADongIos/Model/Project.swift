//
//  Project.swift
//  ADongIos
//
//  Created by Cuongvh on 6/8/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class Project : Codable {
    var id : Int?
    var name : String?
    var createdTime : String?
    var updatedTime : String?
    var address : String?
    var teamType : String?
    var status : String?
    var accountingStatus : Int?
    var createdById : Int?
    var createdByFullName : String?
    var updatedById : Int?
    var updatedByFullName : String?
    var managerId : Int?
    var managerFullName : String?
    var deputyManagerId : Int?
    var deputyManagerFullName : String?
    var secretaryId : Int?
    var secretaryFullName : String?
    var teamId : Int?
    var teamName : String?
    var teamLeaderId : Int?
    var teamLeaderFullName : String?
    var contractorId : Int?
    var contractorName : String?
    var supervisorId : Int?
    var supervisorFullName : String?
    var safetyCriteriaBundleId : Int?
    var safetyCriteriaBundleName : String?
    var qualityCriteriaBundleId : Int?
    var qualityCriteriaBundleName : String?
    var supplyChainCriteriaBundleId : Int?
    var supplyChainCriteriaBundleName : String?
    var secretaryCriteriaBundleId : Int?
    var secretaryCriteriaBundleName : String?
    var latitude : Double?
    var longitude : Double?
    var plannedStartDate : String?
    var plannedEndDate : String?
    var actualStartDate : String?
    var actualEndDate : String?
    
    var projectId : Int?
    var projectAddress : String?
    var projectName : String?
    var designFiles : [DesignFile]?
    
    
    var investorManagerName : String?
    var investorManagerPhone : String?
    var investorManagerEmail : String?
    var investorDeputyManagerName : String?
    var investorDeputyManagerPhone : String?
    var investorDeputyManagerEmail : String?
    
        var investorContacts : investorObject?
    
    
    var typeOfManager : Int?
}


class investorObject : Codable {
    
    var manager : User?
    var deputyManager : User?
    
}

class DesignFile : Codable {
    
    var id : Int?
    var fileSize : Double?
    var downloadUrl : String?
    var fileName : String?
    var createdById : Int?
    var createdByFullName : String?
    var updatedById : Int?
    var updatedByFullName : String?
    
}
