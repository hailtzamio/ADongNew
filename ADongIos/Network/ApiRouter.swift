//
//  APIRouter.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 26/11/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    case getProvinces
    case getDistrict(id:Int)
    
    case login(email:String, password:String)
    case getPermissions
    case getLorries
    case getLorry(id: Int)
    case updateLorry(data: Lorry)
    case removeLorry(id: Int)
    case createLorry(data: Lorry)
    
    case getProducts(page:Int,name:String)
    case getProduct(id: Int)
    case removeProduct(id: Int)
    
    case getWorkers(page:Int,name:String)
    case getWorkersForTeam(page:Int,name:String, type:String)
    case getLeaders(page:Int,name:String)
    case getWorkerNotLeader(page:Int,name:String)
    case getWorker(id: Int)
    case removeWorker(id: Int)
    case updateWorker(data: Worker)
    case createWorker(data: Worker)
    case addWorkerToProject(id: Int, workerId: Int)
    
    
    case getTeams(page:Int,name:String)
    case getTeam(id: Int)
    case removeTeam(id: Int)
    case updateTeam(data: Team)
    case createTeam(data: Team)
    case getTeamWorkers(id: Int)
    
    case getDrivers(page:Int,name:String)
    case getDriver(id: Int)
    case removeDriver(id: Int)
    case updateDriver(data: Driver)
    case createDriver(data: Driver)
    
    case getContractors(page:Int,name:String)
    case getContractor(id: Int)
    case removeContractor(id: Int)
    case updateContractor(data: Contractor)
    case createContractor(data: Contractor)
    
    case getProjects(page:Int,name:String)
    case getProject(id: Int)
    case removeProject(id: Int)
    case updateProject(data: Project)
    case createProject(data: Project)
    case getProjectWokers(id: Int)
    case checkin(data: CheckInOut)
    case checkout(data: CheckInOut)
    case getProjectWokerOutline(id: Int)
    case finishWorkOutline(id: Int)
    
    case getTransports(page:Int,name:String)
    case getTransport(id: Int)
    case getTrips(page:Int,name:String)
    case getTrip(id: Int)
    case transportPickup(id: Int)
    case transportUnload(id: Int)
    case getTransportImages(id: Int)
    case createWarehouse(data : Warehouse)
    case getWarehouses(id:Int,name:String, type : String )
    case getGoodsReceivedNotes
    case getGoodsReceivedNote(id: Int)
    case createGoodsReceivedNote(data: GoodsReceivedNote)
    case getProductRequirements(id: Int)
    case getBiddings(id:Int)
    case projectBiddingApprove(id:Int)
     case getProjectCheckOut(id:Int)
        case getProjectFiles(id:Int)
    
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .createWorker, .createTeam, .createDriver, .createContractor, .createProject,.checkin, .checkout, .createWarehouse, .createGoodsReceivedNote, .createLorry, .addWorkerToProject :
            return .post
        case .updateLorry, .updateWorker, .updateTeam, .updateDriver, .updateContractor, .updateProject, .finishWorkOutline, .transportPickup, .transportUnload, .projectBiddingApprove   :
            return .put
        case .removeProduct, .removeWorker,.removeLorry, .removeTeam, .removeDriver, .removeContractor, .removeProject :
            return .delete
        case .getPermissions, .getProvinces, .getDistrict, .getLorries, .getLorry,
             .getProducts, .getProduct,
             .getWorkers, .getWorker, .getLeaders,
             .getTeams, .getTeam, .getTeamWorkers,
             .getDrivers, .getDriver,
             .getContractors, .getContractor,
             .getProjects, .getProject, .getProjectWokers, .getProjectWokerOutline, .getTransports, .getTrips,.getTrip, .getTransport, .getWorkersForTeam, .getTransportImages, .getWarehouses, .getGoodsReceivedNotes, .getGoodsReceivedNote, .getProductRequirements, .getBiddings, .getWorkerNotLeader, .getProjectCheckOut, .getProjectFiles
            :
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getProvinces :
            return "province"
        case .getDistrict(let id):
            return "province/\(id)/districts"
            
        case .login :
            return "login"
        case .getPermissions:
            return "myPermissions"
        case .getLorries:
            return "lorry"
        case .getLorry(let id):
            return "lorry/\(id)"
        case .updateLorry(let data):
            let id = data.id ?? 0
            return "lorry/\(id)"
        case .createLorry(let data):
            return "lorry"
        case .removeLorry(let id):
            return "lorry/\(id)"
        case .getProducts :
            return "product"
        case .getProduct(let id) :
            return "product/\(id)"
        case .removeProduct(let id):
            return "product/\(id)"
            
        case .getWorkers:
            return "worker"
        case .getWorkerNotLeader:
            return "worker"
        case .getWorkersForTeam:
            return "user"
        case .getLeaders:
            return "worker"
        case .getWorker(let id):
            return "worker/\(id)"
        case .removeWorker(let id):
            return "worker/\(id)"
        case .updateWorker(let data):
            let id = data.id ?? 0
            return "worker/\(id)"
        case .createWorker:
            return "worker"
            
        case .getTeams:
            return "team"
        case .getTeam(let id):
            return "team/\(id)"
        case .removeTeam(let id):
            return "team/\(id)"
        case .updateTeam(let data):
            let id = data.id ?? 0
            return "team/\(id)"
        case .createTeam:
            return "team"
        case .getTeamWorkers(let id):
            return "team/\(id)/members"
            
        case .getDrivers:
            return "driver"
        case .getDriver(let id):
            return "driver/\(id)"
        case .removeDriver(let id):
            return "driver/\(id)"
        case .updateDriver(let data):
            let id = data.id ?? 0
            return "driver/\(id)"
        case .createDriver:
            return "driver"
            
        case .getContractors:
            return "contractor"
        case .getContractor(let id):
            return "contractor/\(id)"
        case .removeContractor(let id):
            return "contractor/\(id)"
        case .updateContractor(let data):
            let id = data.id ?? 0
            return "contractor/\(id)"
        case .createContractor:
            return "contractor"
            
        case .getProjects:
            return "project"
        case .getProject(let id):
            return "project/\(id)"
        case .removeProject(let id):
            return "project/\(id)"
        case .updateProject (let data):
            let id = data.id ?? 0
            return "project/\(id)"
        case .createProject:
            return "project"
        case .getProjectWokers(let id):
            return "project/\(id)/workers"
        case .checkin :
            return "checkin"
        case .checkout :
            return "checkout"
        case .getProjectWokerOutline(let id):
            return "project/\(id)/workOutlines"
            
        case .finishWorkOutline(let id):
            return "projectWorkOutline/\(id)/finish"
        case .getTransports :
            return "transportRequest"
        case .getTrips :
            return "trip"
        case .getTrip(let id):
            return "trip/\(id)"
        case .getTransport(let id):
            return "transportRequest/\(id)"
        case .transportPickup(let id):
            return "transportRequest/\(id)/pickup"
        case .transportUnload(let id):
            return "transportRequest/\(id)/unload"
        case .getTransportImages(let id):
            return "transportRequest/\(id)/photos"
            
        case .createWarehouse :
            return "warehouse"
            
        case .getWarehouses :
            return "warehouse"
            
        case .getGoodsReceivedNotes :
            return "goodsReceivedNote"
            
        case .createGoodsReceivedNote :
            return "goodsReceivedNote"
            
        case .getGoodsReceivedNote(let id):
            return "goodsReceivedNote/\(id)"
        case .getProductRequirements(let id) :
            return "project/\(id)/productRequirements"
        case .getBiddings :
            return "registration"
        case .projectBiddingApprove(let id):
            return "registration/\(id)/approve"
        case .addWorkerToProject(let id, let data):
            return "project/\(id)/addWorker"
            case .getProjectCheckOut(let id) :
                     return "project/\(id)/attendances"
            case .getProjectFiles(let id) :
                              return "project/\(id)/uploadSessions"
            
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [APIParameterKey.email: email, APIParameterKey.password: password]
        case .updateLorry(let data):
            return ["brand": data.brand, "model": data.model,"plateNumber": data.plateNumber, "capacity": data.capacity]
        case .createLorry(let data):
            return ["brand": data.brand, "model": data.model,"plateNumber": data.plateNumber, "capacity": data.capacity]
            
        case .getPermissions, .getProvinces, .getDistrict, .getLorries, .getLorry, .removeLorry, .getProduct, .removeProduct, .getWorker, .removeWorker, .getTeam, .removeTeam, .getTeamWorkers, .removeDriver, .getDriver, .removeContractor,.getContractor, .getProject, .removeProject, .getProjectWokers, .getProjectWokerOutline, .finishWorkOutline, .getTrip, .getTransport, .transportPickup, .transportUnload, .getTransportImages, .getGoodsReceivedNote, .getProductRequirements, .projectBiddingApprove, .getProjectCheckOut, .getProjectFiles :
            return nil
        case .getProducts(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc" ]
        case .getGoodsReceivedNotes :
            return  ["sort" : "id,desc" ]
        case .createWorker(let data):
            return ["address": data.address, "isTeamLeader": data.isTeamLeader,"lineId": data.lineId, "bankName": data.bankName, "bankAccount": data.bankAccount, "fullName": data.fullName, "email": data.email, "phone": data.phone, "phone2": data.phone2, "avatarExtId": data.avatarExtId]
        case .updateWorker(let data):
            return ["address": data.address, "isTeamLeader": data.isTeamLeader,"lineId": data.lineId, "bankName": data.bankName, "bankAccount": data.bankAccount, "fullName": data.fullName, "email": data.email, "phone": data.phone, "phone2": data.phone2, "avatarExtId": data.avatarExtId]
        case .getWorkers(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc"  ]
        case .getWorkerNotLeader(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc", "isTeamLeader" : false ]
        case .getWorkersForTeam(let page, let name, let type) :
            return  [ "authorityCode" : type,"page": page,
                      "name": name, "sort" : "id,desc"  ]
            
        case .getLeaders(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc", "isTeamLeader" : true  ]
        case .getTeams(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc"  ]
        case .createTeam(let data):
            return ["name": data.name, "address": data.address,"phone": data.phone, "phone2": data.phone2, "districtId": data.districtId, "provinceId": data.provinceId, "leaderId": data.leaderId, "memberIds": data.memberIds]
        case .updateTeam(let data):
            return ["name": data.name, "address": data.address,"phone": data.phone, "phone2": data.phone2, "districtId": data.districtId, "provinceId": data.provinceId, "leaderId": data.leaderId, "memberIds": data.memberIds]
            
        case .updateDriver(let data):
            
            return ["fullName": data.fullName,"phone": data.phone, "phone2": data.phone2, "password": data.password, "email": data.email, "avatarExtId": data.avatarExtId]
        case .createDriver(let data):
            
            return ["fullName": data.fullName,"phone": data.phone, "phone2": data.phone2, "password": data.password, "email": data.email, "avatarExtId": data.avatarExtId]
        case .getDrivers(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc"  ]
            
        case .getContractors(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc"  ]
            
        case .createContractor(let data):
            return ["name": data.name,"phone": data.phone, "password": data.password, "address": data.address, "email": data.email, "provinceId": data.provinceId, "districtId": data.districtId]
            
        case .updateContractor(let data):
            return ["name": data.name,"phone": data.phone, "password": data.password, "address": data.address, "email": data.email, "provinceId": data.provinceId, "districtId": data.districtId]
            
        case .createProject(let data):
            return ["name": data.name, "address": data.address,"teamType": data.teamType,"managerId" : data.managerId, "deputyManagerId": data.deputyManagerId, "secretaryId": data.secretaryId, "teamId": data.teamId, "contractorId": data.contractorId, "supervisorId": data.supervisorId, "plannedStartDate": data.plannedStartDate, "plannedEndDate": data.plannedEndDate, "latitude": data.latitude, "longitude": data.longitude]
        case .updateProject(let data):
            return ["name": data.name, "address": data.address,"teamType": data.teamType,"managerId" : data.managerId, "deputyManagerId": data.deputyManagerId, "secretaryId": data.secretaryId, "teamId": data.teamId, "contractorId": data.contractorId, "supervisorId": data.supervisorId, "plannedStartDate": data.plannedStartDate, "plannedEndDate": data.plannedEndDate, "latitude": data.latitude, "longitude": data.longitude]
            
        case .getProjects(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc" ]
            
        case .checkin(let data) :
            return  [ "projectId": data.projectId,
                      "workerIds": data.workerIds]
        case .checkout(let data) :
            return  [ "projectId": data.projectId,
                      "workerIds": data.workerIds]
            
        case .getTransports(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc" ]
        case .getTrips(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc" ]
            
        case .getWarehouses(let page, let name, let type) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc", "type" : type ]
            
        case .createWarehouse(let data):
            return ["name": data.name, "address": data.address,"type": data.type, "keeperId": data.keeperId]
        case .createGoodsReceivedNote(let data):
            
            return ["deliveredBy": data.deliveredBy,"ref": data.ref, "note": data.note, "warehouseId": data.warehouseId, "lines": data.lines]
            
        case .getBiddings(let id) :
            return  [ "projectId": id,
                      "sort" : "id,desc" ]
        case .addWorkerToProject(let id, let workerId):
            return  [
                "workerId" : workerId ]
        }
    }
    
    
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        print(urlRequest)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(ContentType.token.rawValue,forHTTPHeaderField: "Authorization")
        urlRequest.setValue("vi",forHTTPHeaderField: "Accept-Language")
        //        URLEncoding.default
        
        if(path == "uploadAvatar") {
            urlRequest.setValue("multipart/form-data", forHTTPHeaderField: "Content-type")
        }
        
        
        // Parameters
        if(method.rawValue == "POST" || method.rawValue == "PUT" ) {
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
        } else {
            if let parameters = parameters {
                do {
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
                } catch {
                    print("Encoding fail")
                }
            }
        }
        
        return urlRequest
    }
}

