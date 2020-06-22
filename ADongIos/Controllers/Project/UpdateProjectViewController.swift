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
import DLRadioButton
class UpdateProjectViewController: BaseViewController, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
    @IBOutlet weak var tf3: IQDropDownTextField!
    @IBOutlet weak var tf4: IQDropDownTextField!
    @IBOutlet weak var tf5: RadiusTextField!
    @IBOutlet weak var tf6: RadiusTextField!
    
    @IBOutlet weak var tf7: RadiusTextField!
    @IBOutlet weak var tf8: RadiusTextField!
    @IBOutlet weak var tf9: RadiusTextField!
    
    @IBOutlet weak var tf10: RadiusTextField!
    
    @IBOutlet weak var tfTest: IQDropDownTextField!
    @IBOutlet weak var header: NavigationBar!
    
    
    @IBOutlet weak var tf10Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var radio1: DLRadioButton!
    
    @IBOutlet weak var radio2: DLRadioButton!
    @IBOutlet weak var tf10TopSpace: NSLayoutConstraint!
    var data = Project()
    var isUpdate = true // if false Create
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()
        tf3.delegate =  self
        tf3.dropDownMode = .dateTimePicker
        tf3.tag = 1
        
        tf4.dropDownMode = .dateTimePicker
        tf4.delegate =  self
        tf4.tag = 2
        
        
        
        
        if(isUpdate) {
            
            if(data.teamType == "ADONG") {
                tf10Height.constant = 0
                tf10TopSpace.constant = 0
                radio1.isSelected = true
                tf6.text = data.teamName
            } else {
                tf10Height.constant = 45
                tf10TopSpace.constant = 15
                radio2.isSelected = true
                tf6.text = data.contractorName
            }
            tf1.text = data.name
            tf2.text = data.address
            
            tf7.text = data.managerFullName
            tf8.text = data.deputyManagerFullName
            tf9.text = data.secretaryFullName
            tf10.text = data.supervisorFullName
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy at HH:mm"
            let date = formatter.date (from: data.plannedStartDate!)
            tf3.setDate(date, animated: false)
            
        } else {
            
        }
        
    }
    
    //     func openTimePicker()  {
    //        timePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
    //        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height - timePicker.frame.height), width: self.view.frame.width, height: 150.0)
    //         timePicker.backgroundColor = UIColor.white
    //         self.view.addSubview(timePicker)
    //        timePicker.addTarget(self, action: #selector(UpdateProjectViewController.startTimeDiveChanged), for: UIControl.Event.valueChanged)
    //     }
    //
    //    @objc func startTimeDiveChanged(sender: UIDatePicker) {
    //         let formatter = DateFormatter()
    //
    //        formatter.dateStyle = .short
    //        formatter.timeStyle = .short
    //         tf3.text = formatter.string(from: sender.date)
    //
    //        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    //        let dateS = formatter.string(from: sender.date)
    //        print(dateS)
    ////         timePicker.removeFromSuperview() // if you want to remove time picker
    //     }
    
    
    //    @IBAction func btnChooseLeader(_ sender: Any) {
    //        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
    //            vc.isCheckHiden = true
    //            vc.isTypeOfWorker = TypeOfWorker.secretary
    //            vc.isRightButtonHide = true
    //            vc.callback = {(worker) in
    //                //                self.data.leaderId = worker?.id
    //            }
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    
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
    
    
    
    @IBAction func location(_ sender: Any) {
        let vc = MapViewController()
        vc.data = data
        vc.callback = {(coordinate) in
            self.data.latitude = coordinate?.lat
            self.data.longitude = coordinate?.long
            self.tf5.text = coordinate?.name
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chooseTeam(_ sender: Any) {
        if(data.teamType == "ADONG") {
            if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListTeamViewController") as? ListTeamViewController {
                vc.isChooseTeam = true
                vc.callback = {(team) in
                    self.data.teamId = team?.id
                    self.tf6.text = team?.name ?? "---"
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if(data.teamType == "CONTRACTOR") {
            if let vc = UIStoryboard.init(name: "Contractor", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListContractorViewController") as? ListContractorViewController {
                vc.isToChoose = true
                vc.callback = {(team) in
                    self.data.contractorId = team?.id
                    self.tf6.text = team?.name ?? "---"
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
    
    @IBAction func team(_ sender: Any) {
        tf6.text = ""
        tf10Height.constant = 0
        tf10TopSpace.constant = 0
        data.teamType = "ADONG"
    }
    
    @IBAction func contractor(_ sender: Any) {
        tf10Height.constant = 45
        tf10TopSpace.constant = 15
        data.teamType = "CONTRACTOR"
        tf6.text = ""
    }
    
    @IBAction func chooseManager(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = true
            vc.isTypeOfWorker = TypeOfWorker.manager
            vc.isRightButtonHide = true
            vc.callback = {(worker) in
                self.data.managerId = worker?.id
                self.tf7.text = worker?.fullName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func chooseDeputyManager(_ sender: Any) {
        
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = true
            vc.isTypeOfWorker = TypeOfWorker.deputyManager
            vc.isRightButtonHide = true
            vc.callback = {(worker) in
                self.data.deputyManagerId = worker?.id
                self.tf8.text = worker?.fullName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func chooseSecretary(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = true
            vc.isTypeOfWorker = TypeOfWorker.secretary
            vc.isRightButtonHide = true
            vc.callback = {(worker) in
                self.data.secretaryId = worker?.id
                self.tf9.text = worker?.fullName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func chooseSuppervisor(_ sender: Any) {
        
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = true
            vc.isTypeOfWorker = TypeOfWorker.suppervisor
            vc.isRightButtonHide = true
            vc.callback = {(worker) in
                self.data.supervisorId = worker?.id
                self.tf10.text = worker?.fullName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func createOrUpdate(_ sender: Any) {
        
        
        if ( tf1.text == "" || tf2.text == "") {
            showToast(content: "Nhập thiếu thông tin")
            return
        }
        
        if(data.teamType == "ADONG" &&  tf6.text == ""){
            showToast(content: "Chọn đội")
            return
        }
        
        if(data.teamType != "ADONG" &&  tf9.text == ""){
                 showToast(content: "Chọn thư ký")
                 return
        }
        
        
        
        
        data.name = tf1.text
        data.address = tf2.text
        
        
        
        if(isUpdate) {
            // Update
            update(pData: data)
        } else {
            
            
            
            create(pData: data)
        }
    }
    
    func update(pData:Project) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        
        if(tf3.date != nil) {
            data.plannedStartDate = formatter.string(from: tf3.date!)
            
        }
        
        if(tf4.date != nil) {
            data.plannedEndDate = formatter.string(from: tf4.date!)
            
        }
        
        
        
        showLoading()
        APIClient.updateProject(data: pData) { result in
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
    
    func create(pData:Project) {
        
        if(tf3.date == nil || tf4.date == nil) {
            showToast(content: "Chọn ngày")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        data.plannedStartDate = formatter.string(from: tf3.date!)
        data.plannedEndDate = formatter.string(from: tf4.date!)
 
        showLoading()
        APIClient.createProject(data: pData) { result in
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

extension UpdateProjectViewController : IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"
        print("zzzzzzzzzzzzz")
        
        var dateS =  ""
        var dateShow = ""
        
        if let date = formatter.date(from: item ?? "") {
            print(formatter.string(from: date))
            dateShow = formatter.string(from: date)
            
            dateS = formatter2.string(from: date)
        }
        
        switch textField.tag {
        case 1:
            tf1.text = dateS
            data.plannedStartDate = dateShow
            break
        case 2:
            tf2.text = dateS
            data.plannedEndDate = dateShow
            break
            
        default: break
            
        }
        
    }
    
    func getLeader(id : Int) {
        showLoading()
        APIClient.getWorker(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    //                    self.lbLeader.text = value.fullName
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
}


