//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import DateTimePicker
class CreateProductReqViewController: BaseViewController , DateTimePickerDelegate {
    
    var data = [Product]()
    var projectId = 0
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tfSearch: UITextField!
    var endDate = ""
    //
    var isHideTf = true
    var createProductReq = CreateProductReq()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CountViewCell.nib, forCellReuseIdentifier: CountViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        showDatePopup()
    }
    
    func showDatePopup() {
        let min = Date().addingTimeInterval(-0 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(960 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        
        // customize your picker
        //        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        //        picker.locale = Locale(identifier: "en_GB")
        picker.cancelButtonTitle = "Hủy"
        picker.todayButtonTitle = "Hôm nay"
        //        picker.is12HourFormat = true
        picker.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //        picker.isDatePickerOnly = true
        picker.includesMonth = true
        picker.includesSecond = false
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.doneButtonTitle = "ĐỒNG Ý"
        picker.doneBackgroundColor = UIColor.init(hexString: HexColorApp.primary)
        picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: .boldSystemFont(ofSize: 20))
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            self.title = formatter.string(from: date)
        }
        picker.delegate = self
        picker.show()
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        tf2.text = "".convertDateFormatter(date: picker.selectedDateString)
        endDate = picker.selectedDateString
        
    }
    
    func setupHeader() {
        header.title = "Vật Tư"
        tfSearch.returnKeyType = UIReturnKeyType.search
        tfSearch.addPadding(.left(20.0))
        if(!isHideTf) {
            header.changeDoneIcon()
        }
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if(self.isHideTf) {
                if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateProductViewController") as? UpdateProductViewController {
                    vc.isUpdate = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                /// Create
                var lines = [NSDictionary]()
                self.data.forEach { (value) in
                    if(value.count != nil) {
                        
                        let d = LinesAddNew(productId: value.id ?? 0, quantity: Int(value.count!) ?? 0, note: value.note ?? "")
                        lines.append(d.nsDictionary)
                    }
                }
                
                self.createProductReq.expectedDatetime = self.endDate
                self.createProductReq.projectId = self.projectId
                self.createProductReq.note = self.tf1.text ?? ""
                
                if(lines.count == 0) {
                    
                    self.showToast(content: "Chọn vật tư")
                    return
                }
                
                APIClient.createProductRequirement(data : self.createProductReq, lines: lines) { result in
                    //            self.stopLoading()
                    switch result {
                    case .success(let response):
                        self.showToast(content: response.message ?? "Thành công")
                        if(response.status == 1) {
                            self.goBack()
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    
    func createProductRequirement(line : [NSDictionary]) {
        
        //       showLoading()
        
    }
    
    func getData() {
        showLoading()
        APIClient.getProducts(page : 0, name : "") { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data = response.data!
                    self.tbView.reloadData()
                    
                    let total = response.pagination?.totalRecords ?? 0
                    self.tfSearch.placeholder = "Tìm kiếm trong \(total) Vật tư"
                    
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension CreateProductReqViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountViewCell.identifier, for: indexPath) as! CountViewCell
        cell.tf1.isHidden = isHideTf
        if(!isHideTf) {
            cell.newText = {value, type in
                // 1.Count 2.Comment
                print(value)
                switch type {
                case 1:
                    self.data[indexPath.row].count = value
                    break
                case 2:
                    self.data[indexPath.row].note = value
                    break
                default:
                    break
                }
            }
        }
        cell.setDataProduct(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!isHideTf) {
            return
        }
        
        if let vc = UIStoryboard.init(name: "Product", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailProductViewController") as? DetailProductViewController {
            vc.id = data[indexPath.row].id!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//extension  CreateProductReqViewController : UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        //        print(textField.text)
//        //        let quantity = (textField.text ?? "0") as Int
//        data[textField.tag].count = textField.text!
//    }
//    
//}
