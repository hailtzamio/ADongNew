//
//  APIClient.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 14/12/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Alamofire

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:ApiRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
                completion(response.result)
                print(response.response?.statusCode)
                print(response.result)
        }
    }
    
    static func login(email: String, password: String, completion:@escaping (Result<User, AFError>)->Void) {
        performRequest(route: ApiRouter.login(email: email, password: password), completion: completion)
    }
    
    static func getPermissions(completion:@escaping (Result<BaseResponseList<Permission>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getPermissions, decoder: jsonDecoder, completion: completion)
    }
    
    // Product
    static func getProvinces(completion:@escaping (Result<BaseResponseList<Address>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getProvinces, decoder: jsonDecoder, completion: completion)
    }
    
    static func getDistricts(id : Int,completion:@escaping (Result<BaseResponseList<Address>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getDistrict(id: id), decoder: jsonDecoder, completion: completion)
    }
    
    
    // Lorry
    static func getLorries(completion:@escaping (Result<BaseResponseList<Lorry>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getLorries, decoder: jsonDecoder, completion: completion)
    }
    
    static func getLorry(id:Int,completion:@escaping (Result<BaseResponse<Lorry>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getLorry(id: id), decoder: jsonDecoder, completion: completion)
    }
    
    static func updateLorry(data:Lorry,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.updateLorry(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func removeLorry(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
           let jsonDecoder = JSONDecoder()
           jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
           performRequest(route: ApiRouter.removeLorry(id: id), decoder: jsonDecoder, completion: completion)
       }
    
    // Product
    static func getProducts(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Product>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getProducts(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getProduct(id:Int,completion:@escaping (Result<BaseResponse<Product>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getProduct(id: id), decoder: jsonDecoder, completion: completion)
    }
    
    static func removeProduct(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
          performRequest(route: ApiRouter.removeProduct(id: id), decoder: jsonDecoder, completion: completion)
      }
    
    // Worker
    static func getWorkers(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Worker>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getWorkers(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getWorkersForTeam(page : Int, name: String, type : String,completion:@escaping (Result<BaseResponseList<Worker>, AFError>)->Void) {
         let jsonDecoder = JSONDecoder()
         jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getWorkersForTeam(page: page, name: name, type : type), decoder: jsonDecoder, completion: completion)
     }
    
    static func getLeaders(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Worker>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getLeaders(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getWorker(id:Int,completion:@escaping (Result<BaseResponse<Worker>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getWorker(id: id), decoder: jsonDecoder, completion: completion)
    }
    
    static func removeWorker(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
          performRequest(route: ApiRouter.removeWorker(id: id), decoder: jsonDecoder, completion: completion)
      }
    
    static func updateWorker(data:Worker,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.updateWorker(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func createWorker(data:Worker,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.createWorker(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    // Team
      static func getTeams(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Team>, AFError>)->Void) {
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
          performRequest(route: ApiRouter.getTeams(page: page, name: name), decoder: jsonDecoder, completion: completion)
      }
    
    static func createTeam(data:Team,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.createTeam(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func getTeam(id:Int,completion:@escaping (Result<BaseResponse<Team>, AFError>)->Void) {
         let jsonDecoder = JSONDecoder()
         jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
         performRequest(route: ApiRouter.getTeam(id: id), decoder: jsonDecoder, completion: completion)
     }
    
    static func removeTeam(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
          performRequest(route: ApiRouter.removeTeam(id: id), decoder: jsonDecoder, completion: completion)
      }
    
    static func updateTeam(data:Team,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.updateTeam(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func getTeamWorkers(id : Int,completion:@escaping (Result<BaseResponseList<Worker>, AFError>)->Void) {
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
          performRequest(route: ApiRouter.getTeamWorkers(id: id), decoder: jsonDecoder, completion: completion)
      }
    
    
    // Driver
    static func getDrivers(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Driver>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getDrivers(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getDriver(id:Int,completion:@escaping (Result<BaseResponse<Driver>, AFError>)->Void) {
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
          performRequest(route: ApiRouter.getDriver(id: id), decoder: jsonDecoder, completion: completion)
      }
    
    static func removeDriver(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
           let jsonDecoder = JSONDecoder()
           jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
           performRequest(route: ApiRouter.removeDriver(id: id), decoder: jsonDecoder, completion: completion)
       }
    
    static func updateDriver(data:Driver,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.updateDriver(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func createDriver(data:Driver,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.createDriver(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    
    // Contractor
    static func getContractors(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Contractor>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getContractors(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getContractor(id:Int,completion:@escaping (Result<BaseResponse<Contractor>, AFError>)->Void) {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
            performRequest(route: ApiRouter.getContractor(id: id), decoder: jsonDecoder, completion: completion)
        }
    
    static func removeContractor(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
           let jsonDecoder = JSONDecoder()
           jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
           performRequest(route: ApiRouter.removeContractor(id: id), decoder: jsonDecoder, completion: completion)
       }
    
    static func updateContractor(data:Contractor,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.updateContractor(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func createContractor(data:Contractor,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.createContractor(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    // Project
    static func getProjects(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Project>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getProjects(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getProject(id:Int,completion:@escaping (Result<BaseResponse<Project>, AFError>)->Void) {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
            performRequest(route: ApiRouter.getProject(id: id), decoder: jsonDecoder, completion: completion)
        }
    
    static func removeProject(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
           let jsonDecoder = JSONDecoder()
           jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
           performRequest(route: ApiRouter.removeProject(id: id), decoder: jsonDecoder, completion: completion)
       }
    
    static func updateProject(data:Project,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.updateProject(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func createProject(data:Project,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.createProject(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func getProjectWorkers(id : Int,completion:@escaping (Result<BaseResponseList<Worker>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getProjectWokers(id: id), decoder: jsonDecoder, completion: completion)
    }
    
    static func checkin(data:CheckInOut,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
             let jsonDecoder = JSONDecoder()
             jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
             performRequest(route: ApiRouter.checkin(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func checkout(data:CheckInOut,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
         let jsonDecoder = JSONDecoder()
         jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
         performRequest(route: ApiRouter.checkout(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func getProjectWokerOutline(id : Int,completion:@escaping (Result<BaseResponseList<ProgressProject>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getProjectWokerOutline(id: id), decoder: jsonDecoder, completion: completion)
    }
    
    static func finishWorkOutline(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
           let jsonDecoder = JSONDecoder()
           jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
           performRequest(route: ApiRouter.finishWorkOutline(id: id), decoder: jsonDecoder, completion: completion)
       }
    
    
    static func getTransports(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Transport>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getTransports(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getTrips(page : Int, name : String,completion:@escaping (Result<BaseResponseList<Trip>, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getTrips(page: page, name: name), decoder: jsonDecoder, completion: completion)
    }
    
    static func getTrip(id:Int,completion:@escaping (Result<BaseResponse<Trip>, AFError>)->Void) {
               let jsonDecoder = JSONDecoder()
               jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
               performRequest(route: ApiRouter.getTrip(id: id), decoder: jsonDecoder, completion: completion)
           }
    
    static func getTransport(id:Int,completion:@escaping (Result<BaseResponse<Transport>, AFError>)->Void) {
               let jsonDecoder = JSONDecoder()
               jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
               performRequest(route: ApiRouter.getTransport(id: id), decoder: jsonDecoder, completion: completion)
           }
    
    static func transportPickup(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
           let jsonDecoder = JSONDecoder()
           jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
           performRequest(route: ApiRouter.transportPickup(id: id), decoder: jsonDecoder, completion: completion)
       }
    
    static func transportUnload(id:Int,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
            performRequest(route: ApiRouter.transportUnload(id: id), decoder: jsonDecoder, completion: completion)
        }
    
    static func getTransportImages(id : Int, completion:@escaping (Result<BaseResponseList<ImageModel>, AFError>)->Void) {
         let jsonDecoder = JSONDecoder()
         jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
         performRequest(route: ApiRouter.getTransportImages(id: id), decoder: jsonDecoder, completion: completion)
     }
    
    static func getWarehouses(id : Int, name : String, type : String, completion:@escaping (Result<BaseResponseList<Warehouse>, AFError>)->Void) {
         let jsonDecoder = JSONDecoder()
         jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getWarehouses(id: id, name : name, type : type), decoder: jsonDecoder, completion: completion)
     }
    
    static func getGoodsReceivedNotes( completion:@escaping (Result<BaseResponseList<GoodsReceivedNote>, AFError>)->Void) {
         let jsonDecoder = JSONDecoder()
         jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.getGoodsReceivedNotes, decoder: jsonDecoder, completion: completion)
     }
    
    static func createWarehouse(data:Warehouse,completion:@escaping (Result<ResponseDefault, AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        performRequest(route: ApiRouter.createWarehouse(data: data), decoder: jsonDecoder, completion: completion)
    }
    
    static func getGoodsReceivedNote(id:Int,completion:@escaping (Result<BaseResponse<GoodsReceivedNote>, AFError>)->Void) {
               let jsonDecoder = JSONDecoder()
               jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
               performRequest(route: ApiRouter.getGoodsReceivedNote(id: id), decoder: jsonDecoder, completion: completion)
           }
}

