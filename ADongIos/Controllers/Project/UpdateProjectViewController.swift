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
import DateTimePicker
class UpdateProjectViewController: BaseViewController, UINavigationControllerDelegate, DateTimePickerDelegate  {
    
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        if(typeOfTfDate == 1) {
            
            startDate = picker.selectedDateString
            tf3.text = "".convertDateFormatter(date: picker.selectedDateString)
        } else {
          tf4.text = "".convertDateFormatter(date: picker.selectedDateString)
            endDate = picker.selectedDateString
        }
      
    }
    
    
    
    @IBOutlet weak var tf1: RadiusTextField!
    @IBOutlet weak var tf2: RadiusTextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: RadiusTextField!
    @IBOutlet weak var tf6: UIButton!
    
    @IBOutlet weak var tf7: UIButton!
    @IBOutlet weak var tf8: UIButton!
    @IBOutlet weak var tf9: UIButton!
    
    @IBOutlet weak var tf10: UIButton!
    
    
    @IBOutlet weak var header: NavigationBar!
    
    @IBOutlet weak var lb1: UILabel!
    
    @IBOutlet weak var tf10Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var radio1: DLRadioButton!
    @IBOutlet weak var radio2: DLRadioButton!
    @IBOutlet weak var tf10TopSpace: NSLayoutConstraint!
    var project = Project()
    var isUpdate = true // if false Create
    var dialog  =  YesNoPopup.instanceFromNib(title: "TRƯỞNG BỘ PHẬN")
    var dialog2 = YesNoPopup.instanceFromNib(title: "PHÓ BỘ PHẬN")
    var typeOfTfDate = 1
    var startDate = ""
    var endDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHeader()

        if(isUpdate) {
            
            if(project.teamType == "ADONG") {
                radio1.isSelected = true
                tf6.setTitle(project.teamName ?? "Chọn", for: .normal)
            } else {
                radio2.isSelected = true
                tf6.setTitle(project.contractorName ?? "Chọn", for: .normal)
            }
            tf1.text = project.name
            tf2.text = project.address
            tf3.text = "".convertDateFormatter(date: project.plannedStartDate ?? "")
            tf4.text = "".convertDateFormatter(date: project.plannedEndDate ?? "")
            startDate = project.plannedStartDate ?? ""
            endDate = project.plannedEndDate ?? ""
            
            if(project.investorContacts != nil && project.investorContacts?.manager != nil) {
                tf7.setTitle(project.investorContacts?.manager?.name ?? "Chọn", for: .normal)
                project.investorManagerName = project.investorContacts?.manager?.name
            }
            
            if(project.investorContacts != nil && project.investorContacts?.deputyManager != nil) {
                tf8.setTitle(project.investorContacts?.deputyManager?.name ?? "Chọn", for: .normal)
               project.investorDeputyManagerName =  project.investorContacts?.deputyManager?.name
            }
            
       
            tf10.setTitle(project.secretaryFullName ?? "Chọn", for: .normal)
            tf9.setTitle(project.supervisorFullName ?? "Chọn", for: .normal)
            
            
        } else {
            project.teamType = "ADONG"
              radio1.isSelected = true
        }
        
    }
    
    
    @IBAction func chooseDate(_ sender: Any) {
        typeOfTfDate = 1
        test()
        
    }
    
    @IBAction func chooseEndDate(_ sender: Any) {
           typeOfTfDate = 2
          test()
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
        vc.data = project
        vc.callback = {(coordinate) in
            self.project.latitude = coordinate?.lat
            self.project.longitude = coordinate?.long
            self.tf5.text = coordinate?.name
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chooseTeam(_ sender: Any) {
        if(project.teamType == "ADONG") {
            if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListTeamViewController") as? ListTeamViewController {
                vc.isChooseTeam = true
                vc.callback = {(team) in
                    self.project.teamId = team?.id
                    self.tf6.setTitle(team?.name ?? "Chọn", for: .normal)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if(project.teamType == "CONTRACTOR") {
            if let vc = UIStoryboard.init(name: "Contractor", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListContractorViewController") as? ListContractorViewController {
                vc.isToChoose = true
                vc.callback = {(team) in
                    self.project.contractorId = team?.id
                    self.tf6.setTitle(team?.name ?? "Chọn", for: .normal)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
    
    
    
    @IBAction func team(_ sender: Any) {
        project.teamType = "ADONG"
        tf6.setTitle(project.teamName ?? "Chọn", for: .normal)
        lb1.text = "Tên đội *"
    }
    
    func test() {
      let min = Date().addingTimeInterval(-0 * 60 * 24 * 4)
            let max = Date().addingTimeInterval(960 * 60 * 24 * 4)
            let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
            
            // customize your picker
    //        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
    //        picker.locale = Locale(identifier: "en_GB")

    //        picker.todayButtonTitle = "Today"
    //        picker.is12HourFormat = true
            picker.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    //        picker.isDatePickerOnly = true
            picker.includesMonth = true
            picker.includesSecond = false
            picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
            picker.doneButtonTitle = "ĐỒNG Ý"
        picker.doneBackgroundColor = UIColor.init(hexString: HexColorApp.primary)
            picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: .boldSystemFont(ofSize: 20))
    //        if #available(iOS 13.0, *) {
    //            picker.normalColor = UIColor.secondarySystemGroupedBackground
    //            picker.darkColor = UIColor.label
    //            picker.contentViewBackgroundColor = UIColor.systemBackground
    //            picker.daysBackgroundColor = UIColor.groupTableViewBackground
    //            picker.titleBackgroundColor = UIColor.secondarySystemGroupedBackground
    //        } else {
    //            picker.normalColor = UIColor.white
    //            picker.darkColor = UIColor.black
    //            picker.contentViewBackgroundColor = UIColor.white
    //        }
            picker.completionHandler = { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
                self.title = formatter.string(from: date)
            }
            picker.delegate = self
            
            // add picker to your view
            // don't try to make customize width and height of the picker,
            // you'll end up with corrupted looking UI
    //        picker.frame = CGRect(x: 0, y: 100, width: picker.frame.size.width, height: picker.frame.size.height)
            // set a dismissHandler if necessary
    //        picker.dismissHandler = {
    //            picker.removeFromSuperview()
    //        }
    //        self.view.addSubview(picker)
            
            // or show it like a modal
            picker.show()
    
    }
    
    @IBAction func contractor(_ sender: Any) {
        project.teamType = "CONTRACTOR"
        tf6.setTitle(project.contractorName ?? "Chọn", for: .normal)
 
        lb1.text = "Tên đội"
    }
    

    @IBAction func chooseManager(_ sender: Any) {
        
        
//        project.typeOfManager = 1
//
//        if(isUpdate) {
//           dialog =  YesNoPopup.instanceFromNib(data : project, title: "TRƯỞNG BỘ PHẬN")
//        }
        
        dialog.ok = {(worker) in
            print(worker.fullName)
            self.tf7.setTitle(worker.fullName ?? "Chọn", for: .normal)
            self.project.investorManagerName = worker.fullName
            self.project.investorManagerPhone = worker.phone
            
            if(worker.email != nil) {
                self.project.investorManagerEmail = worker.email
            }
        }
        dialog.show()
    }
    
    
    @IBAction func chooseDeputyManager(_ sender: Any) {
        
//        project.typeOfManager = 2
        
//        if(isUpdate) {
//          dialog2 =  YesNoPopup.instanceFromNib(data : project, title: "TRƯỞNG BỘ PHẬN")
//        }
        
        dialog2.ok = {(worker) in
            print(worker.fullName)
            self.tf8.setTitle(worker.fullName ?? "Chọn", for: .normal)
            self.project.investorDeputyManagerName = worker.fullName
            self.project.investorDeputyManagerPhone = worker.phone
            
            if(worker.email != nil) {
                self.project.investorDeputyManagerEmail = worker.email
            }
        }
        dialog2.show()
        
        
        //        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
        //            vc.isCheckHiden = true
        //            vc.isTypeOfWorker = TypeOfWorker.deputyManager
        //            vc.isRightButtonHide = true
        //            vc.callback = {(worker) in
        //                self.data.deputyManagerId = worker?.id
        //                self.tf8.text = worker?.fullName
        //            }
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    @IBAction func chooseSecretary(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseWorkerViewController") as? ChooseWorkerViewController {
            vc.isCheckHiden = true
            vc.isTypeOfWorker = TypeOfWorker.secretary
            vc.isRightButtonHide = true
            vc.callback = {(worker) in
                self.project.secretaryId = worker?.id
                self.tf10.setTitle(worker?.fullName ?? "Chọn", for: .normal)
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
                self.project.supervisorId = worker?.id
                self.tf9.setTitle(worker?.fullName ?? "Chọn", for: .normal)
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func createOrUpdate(_ sender: Any) {
        
        
        if ( tf1.text == "" || tf2.text == "") {
            showToast(content: "Nhập thiếu thông tin")
            return
        }

        project.name = tf1.text
        project.address = tf2.text
        

        if(isUpdate) {
            // Update
            update(pData: project)
        } else {
            create(pData: project)
        }
    }
    
    func update(pData:Project) {
        
        if(tf3.text != "") {
            pData.plannedStartDate = startDate
        }
        
        if(tf4.text != "") {
            pData.plannedEndDate = endDate
            
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
        
        if(tf3.text == "" || tf4.text == "") {
            showToast(content: "Chọn ngày")
            return
        }

        project.plannedStartDate = startDate
        project.plannedEndDate = endDate
        

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
            project.plannedStartDate = dateShow
            break
        case 2:
            tf2.text = dateS
            project.plannedEndDate = dateShow
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


