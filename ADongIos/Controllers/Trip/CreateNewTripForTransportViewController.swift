//
//  UpdateViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire
import IQDropDownTextField
class CreateNewTripForTransportViewController: BaseViewController {
    
    @IBOutlet weak var header: NavigationBar!
    var data:Lorry? = nil
    var transports = [Transport]()
var tripReq = Trip()
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
    @IBOutlet weak var tf3: RadiusTextField!

    @IBOutlet weak var tfTime: IQDropDownTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        
     tfTime.dropDownMode = .dateTimePicker
       tfTime.tag = 2
    }
    
    

    
    func setupHeader() {
        header.title = "Tạo Chuyến Đi"
  
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    func checkValidate() {
//        if ( tfBrand.text == "" || tfCapacity.text == "" || tfPlateNumber.text == "" || tfModel.text == "") {
//            showToast(content: "Nhập thiếu thông tin")
//            return
//        }
    }
    
    @IBAction func chooseLorry(_ sender: Any) {
        
        if let vc = UIStoryboard.init(name: "Lorry", bundle: Bundle.main).instantiateViewController(withIdentifier: "LorryListViewController") as? LorryListViewController {
               vc.isToChoose = true
            vc.callback = {(lorry) in
                self.tf1.text = lorry?.model
                self.tripReq.lorryId = lorry?.id ?? 0
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
    @IBAction func btnChooseDate(_ sender: Any) {
        
    }
    
    
    @IBAction func chooseDriver(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Driver", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListDriverViewController") as? ListDriverViewController {
            
            
            vc.isToChoose = true
                  vc.callback = {(driver) in
                    self.tf2.text = driver?.fullName
                      self.tripReq.driverId = driver?.id ?? 0
                  }
                  
            navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    
    
    @IBAction func createOrUpdate(_ sender: Any) {
          
        
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if(tfTime.date != nil) {
                tripReq.plannedDatetime = formatter.string(from: tfTime.date!)
            }
        
        var transIds = [Int]()
        
        transports.forEach { (trans) in
            transIds.append(trans.id!)
        }
           
        tripReq.transportReqIds = transIds
    
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try? jsonEncoder.encode(tripReq)
                        let json = String(data: jsonData!, encoding: String.Encoding.utf8)
                                   
                                   print(json)
                   

        showLoading()
        APIClient.createTrip(data: tripReq) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
                    self.showToast(content: "Thành công")
                    self.goBack()
                    return
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
      }
    
  
}
