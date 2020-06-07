//
//  UpdateViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TOCropViewController
import IQDropDownTextField
class UpdateTeamViewController: BaseViewController, UINavigationControllerDelegate {
    
    
    var provincesStr = [String]()
    var provinces = [Address]()
    var provinceId = 1
    
    var districtStr = [String]()
    var districts = [Address]()
    var districtId = 1
    
    @IBOutlet weak var tf3: IQDropDownTextField!
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
    @IBOutlet weak var tf4: IQDropDownTextField!
    @IBOutlet weak var tf5: RadiusTextField!
    @IBOutlet weak var tf6: RadiusTextField!
    @IBOutlet weak var header: NavigationBar!
    
    @IBOutlet weak var lbLeader: RadiusTextField!
    
    @IBOutlet weak var bt1: UIButton!
    
    var data = Team()
    var isUpdate = true // if false Create
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        
        if(isUpdate) {
            tf1.text = data.name
            tf2.text = data.address
            tf5.text = data.phone
            tf6.text = data.phone2
            bt1.setTitle( "ĐỒNG Ý" , for: .normal )
            
            if(data.provinceId != nil) {
                provinceId = data.provinceId!
                getDistrict()
            }
            
            if(data.districtId != nil) {
                districtId = data.districtId!
            }
            
            getLeader(id : data.leaderId ?? 0)
        } else {
            provinceId = 1
            data.provinceId = 1
            data.provinceName = "Hà Nội"
            
            districtId = 1
            data.districtId = 1
            data.districtName = "Ba Đình"
        }
        
        getProvice()
        
    }
    
    @IBAction func btnChooseLeader(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = true
            vc.isTypeOfWorker = TypeOfWorker.leader
            vc.isRightButtonHide = true
            vc.callback = {(worker) in
                self.lbLeader.text = worker?.fullName
                self.data.leaderId = worker?.id
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupHeader() {
        header.title = "Cập Nhật"
        if(!isUpdate) {
            header.title = "Tạo Mới"
        }
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    @IBAction func createOrUpdate(_ sender: Any) {
        
        if ( tf1.text == "" || tf2.text == "" || tf5.text == "" ) {
            showToast(content: "Nhập thiếu thông tin")
            return
        }
        
        if(districtId == -1){
            showToast(content: "Chọn Quận/Huyện")
            return
        }
        
        data.name = tf1.text
        data.address = tf2.text
        data.phone = tf5.text
        data.phone2 = tf6.text
        data.provinceId = provinceId
        data.districtId = districtId
        
        if(isUpdate) {
            // Update
            update(pData: data)
        } else {
            GoToChooseWorkers(pData: data)
        }
    }
    
    func update(pData:Team) {
        
        showLoading()
        APIClient.updateTeam(data: pData) { result in
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
    
    func GoToChooseWorkers(pData:Team) {
        
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = false
            vc.team = pData
            vc.goBackToPreviousVc = {
                          self.goBack()
                }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UpdateTeamViewController : IQDropDownTextFieldDelegate {
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        
        switch textField.tag {
        case 1:
            for i in 0..<provinces.count {
                if provinces[i].name == item {
                    provinceId = provinces[i].id!
                    districtStr.removeAll()
                    districts.removeAll()
                    districtId = -1
                    self.getDistrict()
                }
            }
            break
        case 2:
            for i in 0..<districts.count {
                if districts[i].name == item {
                    districtId = districts[i].id!
                }
            }
            
            break
            
        default: break
            
        }
        
        
    }
    
    func getProvice() {
        
        showLoading()
        APIClient.getProvinces { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.provinces = response.data!
                    self.getDistrict()
                    self.setupProvinceView()
                    
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func getDistrict () {
        showLoading()
        APIClient.getDistricts(id : provinceId) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.districts = response.data!
                    self.setupDistrictView()
                    
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func setupDistrictView() {
        for i in 0..<districts.count {
            self.districtStr.append((self.districts[i].name)!)
        }
        self.tf4.isOptionalDropDown = true
        self.tf4.delegate =  self
        self.tf4.itemList = self.districtStr
        self.tf4.tag = 2
        self.tf4.setSelectedItem(data.districtName, animated: false)
    }
    
    func setupProvinceView() {
        for i in 0..<provinces.count {
            self.provincesStr.append((self.provinces[i].name)!)
        }
        self.tf3.isOptionalDropDown = true
        self.tf3.delegate =  self
        self.tf3.itemList = self.provincesStr
        self.tf3.tag = 1
        self.tf3.setSelectedItem(data.provinceName, animated: false)
    }
    
    func getLeader(id : Int) {
        showLoading()
        APIClient.getWorker(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.lbLeader.text = value.fullName
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
}


