//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ListWorkerViewController: BaseViewController, UISearchBarDelegate, LoadMoreControlDelegate {
    
    var data = [Worker]()
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var page = 0
    var totalPages = 0
    var total = 0
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var loadMoreControl: LoadMoreControl!
    
    @IBOutlet weak var tfSearch: UITextField!
    // For Adding To Team
    var isToChooseWorker = false
    var team:Team? = nil
    var chooseWorkerId = 0
    var workers = [Worker]()
    var worker = Worker()
    var callback : ((Int?) -> Void)?
    
    var isAddWorkerToProject = false
    var projectId = 0
    
    var isCheckHiden = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CommonTableViewCell.nib, forCellReuseIdentifier: CommonTableViewCell.identifier)
        
        loadMoreControl = LoadMoreControl(scrollView: tbView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreControl.delegate = self
        
        if(isToChooseWorker) {
            header.isRightButtonHide = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 0
        data.removeAll()
        if(isAddWorkerToProject) {
            getWorkerNotLeader()
        } else {
            getData()
        }
        
    }
    
    
    
    func setupHeader() {
        header.title = "Công Nhân"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateWorkerViewController") as? UpdateWorkerViewController {
                vc.isUpdate = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
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
    
    func getWorkerNotLeader() {
        showLoading()
        APIClient.getWorkerNotLeader(page : page, name : tfSearch.text ?? "") { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data.append(contentsOf: response.data!)
                    self.tbView.reloadData()
                    if(response.pagination != nil && response.pagination?.totalPages != nil) {
                        if(self.total == 0) {
                            self.total = response.pagination?.totalRecords ?? 0
                        }
                        self.tfSearch.placeholder = "Tìm kiếm trong \(self.total) Công nhân"
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
    
    func getData() {
        showLoading()
        APIClient.getWorkers(page : page, name : tfSearch.text ?? "") { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data.append(contentsOf: response.data!)
                    self.tbView.reloadData()
                    if(response.pagination != nil && response.pagination?.totalPages != nil) {
                        let total = response.pagination?.totalRecords ?? 0
                        self.tfSearch.placeholder = "Tìm kiếm trong \(total) Công nhân"
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

extension ListWorkerViewController: UITableViewDataSource, UITableViewDelegate, checkItem {
    
    
    func doCheck(position: Int) {
        data[position].isSelected = !(data[position].isSelected ?? false) 
        tbView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewCell.identifier, for: indexPath) as! CommonTableViewCell
        cell.setDataWorker(data: data[indexPath.row])
        cell.check = self
        cell.imvStatus.isHidden = !isCheckHiden
        cell.imvCheck.isHidden = isCheckHiden
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isToChooseWorker) {
            worker = data[indexPath.row]
            workers.insert(data[indexPath.row], at: 0)
            showYesNoPopup(title: "Xác nhận", message: "Chọn Công nhân này?")
        } else {
            if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailWorkerViewController") as? DetailWorkerViewController {
                vc.id = data[indexPath.row].id!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreControl.didScroll()
    }
}

extension ListWorkerViewController {
    
    func popupHandle() {
        okAction = {
            if(self.isAddWorkerToProject) {
                self.addWorkerToProject()
            } else {
                self.addWorkerToTeam()
            }
        }
        
        noAction = {
            self.workers.remove(at: 0)
        }
    }
    
    func addWorkerToTeam() {
        
        var memberIds = [Int]()
        for i in 0..<workers.count {
            memberIds.append(workers[i].id!)
        }
        
        team?.memberIds = memberIds
        
        self.showLoading()
        APIClient.updateTeam(data : team!) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
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
    
    func addWorkerToProject() {
        self.showLoading()
        APIClient.addWorkerToProject(id : projectId, workerId: worker.id!) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if response.status == 1 {
                    self.showToast(content: "Thành công")
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


