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
     case getMyProfile
    case login(email:String, password:String)
    case getPermissions
    case getLorries
    case getLorry(id: Int)
    case updateLorry(data: Lorry)
    case removeLorry(id: Int)
    case createLorry(data: Lorry)
    
    case createProduct(data: Product)
       case updateProduct(data: Product)
    case getProducts(page:Int,name:String)
    case getProduct(id: Int)
    case removeProduct(id: Int)
    
    case getWorkers(page:Int,name:String)
    case getWorkersNotInTeam(page:Int,name:String)
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
    
    case getProjects(page:Int,name:String, status:String, size: Int)
    case getProject(id: Int)
    case removeProject(id: Int)
       case pauseProject(id: Int)
          case resumeProject(data: Project)
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
    case getGoodsIssueDoccuments
    case getGoodsIssueRequests
    case getManuFactureRequest
    case getManuFactureRequestById(id: Int)
    case getGoodsReceivedNote(id: Int)
    case createGoodsReceivedNote(data: GoodsReceivedNote)
    case getProductRequirements(id: Int)
    case getGoodsRequest(id: Int)
    
    case getBiddings(id:Int)
    case projectBiddingApprove(id:Int)
    case getProjectCheckOut(id:Int)
    case getProjectFiles(id:Int)
    case finishProject(id: Int)
        case getProjectImages(id: Int)
      case getProjectCompletionImages(id: Int)
        case createProductRequirement(data: CreateProductReq)
    
        case createTrip(data: Trip)
    case getNotifications
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .createWorker, .createTeam, .createDriver, .createContractor, .createProject,.checkin, .checkout, .createWarehouse, .createGoodsReceivedNote, .createLorry, .addWorkerToProject, .createProductRequirement, .createTrip, .createProduct :
            return .post
        case .updateLorry, .updateWorker, .updateTeam, .updateDriver, .updateContractor, .updateProject, .finishWorkOutline, .transportPickup, .transportUnload, .projectBiddingApprove, .finishProject, .updateProduct, .pauseProject , .resumeProject   :
            return .put
        case .removeProduct, .removeWorker,.removeLorry, .removeTeam, .removeDriver, .removeContractor, .removeProject :
            return .delete
        case .getPermissions, .getProvinces, .getDistrict, .getLorries, .getLorry,
             .getProducts, .getProduct,
             .getWorkers, .getWorker, .getLeaders,
             .getTeams, .getTeam, .getTeamWorkers,
             .getDrivers, .getDriver,
             .getContractors, .getContractor,
             .getProjects, .getProject, .getProjectWokers, .getProjectWokerOutline, .getTransports, .getTrips,.getTrip, .getTransport, .getWorkersForTeam, .getTransportImages, .getWarehouses, .getGoodsReceivedNotes, .getGoodsReceivedNote, .getProductRequirements, .getBiddings, .getWorkerNotLeader, .getProjectCheckOut, .getProjectFiles, .getProjectImages, .getProjectCompletionImages, .getManuFactureRequest, .getManuFactureRequestById, .getGoodsIssueDoccuments, .getGoodsIssueRequests, .getGoodsRequest, .getNotifications,  .getMyProfile, .getWorkersNotInTeam
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
            case .getMyProfile :
                   return "myProfile"
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
            
            case .updateProduct(let data):
                let id = data.id ?? 0
                return "product/\(id)"
        case .createLorry(let data):
            return "lorry"
        case .removeLorry(let id):
            return "lorry/\(id)"
        case .createProduct:
            return "product"
            
        case .getProducts :
            return "product"
        case .getProduct(let id) :
            return "product/\(id)"
        case .removeProduct(let id):
            return "product/\(id)"
            
        case .getWorkers:
            return "worker"
            case .getWorkersNotInTeam:
                      return "worker"
        case .getWorkerNotLeader:
            return "worker"
        case .getWorkersForTeam:
            return "user"
        case .getLeaders:
            return "worker"
        case .getWorker(let id):
            return "worker/\(id)"
            case .getGoodsRequest(let id):
                      return "goodsIssueRequest/\(id)"
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
        case .getNotifications:
            return "myNotifications"
            
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
            case .pauseProject(let id):
                   return "project/\(id)/pause"
            case .resumeProject(let data):
                 let id = data.id ?? 0
                return "project/\(id)/resume"
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
            return "trip/\(id)/photos"
        case .getProjectImages(let id):
                 return "project/\(id)/checkinPhotos"
                 case .getProjectCompletionImages(let id):
                               return "project/\(id)/projectCompletionPhotos"
            
            
        case .createWarehouse :
            return "warehouse"
            
        case .getWarehouses :
            return "warehouse"
            
        case .getManuFactureRequest :
            return "manufactureRequest"
            
            case .getGoodsReceivedNotes :
                  return "goodsReceivedNote"
            case .getGoodsIssueDoccuments :
                  return "goodsIssueDocument"
   
            case .getGoodsIssueRequests :
                             return "goodsIssueRequest"
            
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
        case .finishProject(let id) :
            return "project/\(id)/finish"
            case .createProductRequirement(let data) :
                  let id = data.projectId ?? 0
                 return "project/\(id)/productRequirement"
            
            case .createTrip(let data):
                  return "trip"
            case .getManuFactureRequestById(let id) :
                      return "manufactureRequest/\(id)"
            
            
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
            
        case .getPermissions, .getProvinces, .getDistrict, .getLorries, .getLorry, .removeLorry, .getProduct, .removeProduct, .getWorker, .removeWorker, .getTeam, .removeTeam, .getTeamWorkers, .removeDriver, .getDriver, .removeContractor,.getContractor, .getProject, .removeProject, .getProjectWokers, .getProjectWokerOutline, .finishWorkOutline, .getTrip, .getTransport, .transportPickup, .transportUnload, .getTransportImages, .getGoodsReceivedNote, .getProductRequirements, .projectBiddingApprove, .getProjectCheckOut, .getProjectFiles, .finishProject, .getProjectImages, .getProjectCompletionImages, .getManuFactureRequest, .getManuFactureRequestById, .getGoodsIssueDoccuments, .getGoodsIssueRequests, .getGoodsRequest, .getNotifications, .getMyProfile:
            return nil
            
        case .pauseProject :
            return [ "note": "Tạm dừng công trình" ]
         case .resumeProject(let data) :
            
            if(data.teamId == nil) {
                     return ["teamType": data.teamType, "contractorId": data.contractorId ?? 0, "note": "Phục hồi công trình" ]
            } else {
            
                  return ["teamType": data.teamType,"teamId": data.teamId ?? 0, "note": "Phục hồi công trình" ]
            }
            
      
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
                      "fullName": name, "sort" : "id,desc"  ]
            case .getWorkersNotInTeam(let page, let name) :
                     return  [ "page": page,
                               "fullName": name, "sort" : "id,desc", "inTeam" : false ]
        case .getWorkerNotLeader(let page, let name) :
            return  [ "page": page,
                      "name": name, "sort" : "id,desc", "isTeamLeader" : false ]
        case .getWorkersForTeam(let page, let name, let type) :
            return  [ "authorityCode" : type,"page": page,
                      "name": name, "sort" : "id,desc", "inTeam" : false  ]
            
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
            return ["name": data.name, "address": data.address,"teamType": data.teamType,"managerId" : data.managerId, "deputyManagerId": data.deputyManagerId, "secretaryId": data.secretaryId, "teamId": data.teamId, "contractorId": data.contractorId, "supervisorId": data.supervisorId, "plannedStartDate": data.plannedStartDate, "plannedEndDate": data.plannedEndDate, "latitude": data.latitude, "longitude": data.longitude,"investorManagerName": data.investorManagerName,"investorManagerPhone": data.investorManagerPhone,"investorManagerEmail": data.investorManagerEmail,"investorDeputyManagerName": data.investorDeputyManagerName,"investorDeputyManagerPhone": data.investorDeputyManagerPhone,"investorDeputyManagerEmail": data.investorDeputyManagerEmail]
        case .updateProject(let data):
            return ["name": data.name, "address": data.address,"teamType": data.teamType,"managerId" : data.managerId, "deputyManagerId": data.deputyManagerId, "secretaryId": data.secretaryId, "teamId": data.teamId, "contractorId": data.contractorId, "supervisorId": data.supervisorId, "plannedStartDate": data.plannedStartDate, "plannedEndDate": data.plannedEndDate, "latitude": data.latitude, "longitude": data.longitude,"investorManagerName": data.investorManagerName,"investorManagerPhone": data.investorManagerPhone,"investorManagerEmail": data.investorManagerEmail,"investorDeputyManagerName": data.investorDeputyManagerName,"investorDeputyManagerPhone": data.investorDeputyManagerPhone,"investorDeputyManagerEmail": data.investorDeputyManagerEmail]
            
        case .getProjects(let page, let name, let status, let size) :
            return  [ "page": page,
                      "search": name, "status" : status, "sort" : "id,desc", "size" : size ]
            
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
        case .createProductRequirement(let data):
                     return ["note": data.note ?? "", "expectedDatetime": data.expectedDatetime ?? "","linesAddNew": data.linesAddNew ?? [Product]()]
            
            case .createTrip(let data):
                     return ["plannedDatetime": data.plannedDatetime, "lorryId": data.lorryId,"driverId": data.driverId, "transportReqIds": data.transportReqIds,"note": data.note]
            
            case .createProduct(let data):
                      
                      return ["name": data.name,"type": data.type, "thumbnailExtId": data.thumbnailExtId, "unit": data.unit, "code": data.code]
            
            case .updateProduct(let data):
                           
                           return ["name": data.name,"type": data.type, "thumbnailExtId": data.thumbnailExtId, "unit": data.unit, "code": data.code]
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
        urlRequest.setValue(Context.AccessToken,forHTTPHeaderField: "Authorization")
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

