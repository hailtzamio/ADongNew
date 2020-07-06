//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ChooseWorkerViewController: BaseViewController, UISearchBarDelegate, LoadMoreControlDelegate {
    
    var data = [Worker]()
    var dataChoose = [Worker]()
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var page = 0
    var totalPages = 0
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var loadMoreControl: LoadMoreControl!
    
    @IBOutlet weak var tfSearch: UITextField!
    // For Adding To Team
    var team:Team? = nil
    var chooseWorkerId = 0
    var callback : ((Worker?) -> Void)?
    var callbackList : (([Worker]?) -> Void)?
    var goBackToPreviousVc : (() -> ())?
    
    var isCheckHiden = true
    var isTypeOfWorker = TypeOfWorker.worker
    
    var isRightButtonHide = false
    var isChooseWorkerForTeam = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CommonTableViewCell.nib, forCellReuseIdentifier: CommonTableViewCell.identifier)
        
        loadMoreControl = LoadMoreControl(scrollView: tbView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreControl.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 0
        data.removeAll()
        
        switch isTypeOfWorker {
        case TypeOfWorker.worker:
            getData()
            header.title = "Công Nhân"
            break
        case TypeOfWorker.leader :
            header.title = "Đội Trưởng"
            getLeaders()
            break
        case TypeOfWorker.manager :
            header.title = "Trưởng Bộ Phận"
            getWorkersForTeam(type: "MANAGER")
            break
        case TypeOfWorker.deputyManager :
            header.title = "Phó Bộ Phận"
            getWorkersForTeam(type: "DEPUTY_MANAGER")
            break
        case TypeOfWorker.secretary :
            header.title = "Thư Ký"
            getWorkersForTeam(type: "SECRETARY")
            break
        case TypeOfWorker.suppervisor :
            header.title = "Quản Lý Vùng"
            getWorkersForTeam(type: "AREA_MANAGER")
            break
        case TypeOfWorker.keeper :
            header.title = "Thư Ký"
            getWorkersForTeam(type: "WAREHOUSE_KEEPER")
            break
        default:
            break
        }
    }
    
    func setupHeader() {
        
        header.changeDoneIcon()
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if(self.isChooseWorkerForTeam) {
                
                var members = [Worker]()
                for i in 0..<self.data.count {
                    if(self.data[i].isSelected ?? false) {
                        members.append(self.data[i])
                    }
                }
                
                self.callbackList!(members)
                self.goBack()
            } else {
                self.showYesNoPopup(title: "Xác nhận", message: "Tạo Đội thi công?")
            }
            
        }
        
        header.isRightButtonHide = isRightButtonHide
        tfSearch.addPadding(.left(20.0))
        tfSearch.returnKeyType = UIReturnKeyType.search
        tfSearch.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
    }
    
    @objc func enterPressed(){
        //do something with typed text if needed
        tfSearch.resignFirstResponder()
        page = 0
        data.removeAll()
        getData()
    }
    
    func getData() {
        showLoading()
        APIClient.getWorkersNotInTeam(page : page, name : tfSearch.text ?? "") { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data.append(contentsOf: response.data!)
                    self.tbView.reloadData()
                    if(response.pagination != nil && response.pagination?.totalPages != nil) {
                        self.totalPages = response.pagination?.totalPages as! Int
                        self.page = self.page + 1
                    }
                    
                    for i in 0..<self.data.count {
                        for j in 0..<self.dataChoose.count {
                            if(self.data[i].id == self.dataChoose[j].id) {
                                self.data[i].isSelected = true
                            }
                        }
                    }
                    
                    
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func getWorkersForTeam(type: String) {
        showLoading()
        APIClient.getWorkersForTeam(page : page, name : tfSearch.text ?? "", type: type) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data.append(contentsOf: response.data!)
                    
                    if(response.pagination != nil && response.pagination?.totalPages != nil) {
                        self.totalPages = response.pagination?.totalPages as! Int
                        self.page = self.page + 1
                    }
                    
                    
                    for i in 0..<self.data.count {
                        for j in 0..<self.dataChoose.count {
                            if(self.data[i].id == self.dataChoose[j].id) {
                                self.data[i].isSelected = true
                            }
                        }
                    }
                    
                    
                    self.tbView.reloadData()
                    
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func getLeaders() {
        showLoading()
        APIClient.getLeaders(page : page, name : tfSearch.text ?? "") { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data.append(contentsOf: response.data!)
                    self.tbView.reloadData()
                    if(response.pagination != nil && response.pagination?.totalPages != nil) {
                        self.totalPages = response.pagination?.totalPages as! Int
                        self.page = self.page + 1
                    }
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
    
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl) {
        print(" \(page) \(totalPages)")
        if page < totalPages {
            getData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
            self?.loadMoreControl.stop()
        }
    }
    
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl) {
        
    }
    
}

extension ChooseWorkerViewController: UITableViewDataSource, UITableViewDelegate, checkItem {
    
    
    func doCheck(position: Int) {
        
        data[position].isSelected = !(data[position].isSelected ?? false)
        
        data.forEach { (worker) in
            if(worker.isSelected ?? false) {
                dataChoose.append(worker)
            }
        }
        
        tbView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.identifier, for: indexPath) as! CommonTableViewCell
        cell.setDataWorker(data: data[indexPath.row])
        cell.check = self
        cell.imvCheck.isHidden = isCheckHiden
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isCheckHiden) {
            callback!(data[indexPath.row])
            goBack()
        }
        
        //                if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailWorkerViewController") as? DetailWorkerViewController {
        //                    vc.id = data[indexPath.row].id!
        //                    navigationController?.pushViewController(vc, animated: true)
        //                }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreControl.didScroll()
    }
}

extension ChooseWorkerViewController {
    
    func popupHandle() {
        okAction = {
            self.createTeam()
        }
    }
    
    func createTeam() {
        
        var memberIds = [Int]()
        for i in 0..<data.count {
            if(data[i].isSelected ?? false) {
                memberIds.append(data[i].id!)
            }
        }
        
        team?.memberIds = memberIds
        
        self.stopLoading()
        APIClient.createTeam(data : team!) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
                    self.goBack()
                    self.goBackToPreviousVc!()
                    self.showToast(content: "Thành công")
                    return
                }else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
    }
}


