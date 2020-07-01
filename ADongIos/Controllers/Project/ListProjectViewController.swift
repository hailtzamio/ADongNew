//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ListProjectViewController: BaseViewController, LoadMoreControlDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    
    
    
    
    
    var data = [Project]()
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var page = 0
    var totalPages = 0
    
    @IBOutlet weak var tfSearch: UITextField!
    var removeTeamId = 0
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var textSearch = ""
    var filterType = ""
    var loadMoreControl: LoadMoreControl!
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle()
        hideKeyboardWhenTappedAround()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(ProjectViewCell.nib, forCellReuseIdentifier: ProjectViewCell.identifier)
        
        loadMoreControl = LoadMoreControl(scrollView: tbView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreControl.delegate = self
        
        //        searchBar.delegate = self
        //        searchBar.showsCancelButton = true
        
        tfSearch.returnKeyType = UIReturnKeyType.search
        tfSearch.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        //        search.barTintColor = UIColor.init(hexString: HexColorApp.gray)
        //          search.tintColor = UIColor.init(hexString: HexColorApp.green)
        //        search.delegate = self
        
        //        searchController.searchBar.delegate = self
        //        searchController.searchResultsUpdater = self
        //        searchController.dimsBackgroundDuringPresentation = true
        //        definesPresentationContext = false
        //        tbView.tableHeaderView = searchController.searchBar
        //        searchController.searchBar.tintColor = UIColor.white
        //        searchController.searchBar.barTintColor = UIColor.init(hexString: HexColorApp.primary)
        
        
        //        if #available(iOS 11.0, *) {
        //            navigationItem.searchController = searchController
        //        } else {
        //
        //        }
        
    }
    
    @objc func enterPressed(){
        //do something with typed text if needed
        tfSearch.resignFirstResponder()
        textSearch = tfSearch.text ?? ""
        page = 0
        data.removeAll()
        getData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        page = 0
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Công Trình"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateProjectViewController") as? UpdateProjectViewController {
                vc.isUpdate = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        tfSearch.addPadding(.left(20.0))
    }
    
    func getData() {
        showLoading()
        APIClient.getProjects(page : page, name : textSearch, status : filterType, size : 50) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data.append(contentsOf: response.data!)
                    self.tbView.reloadData()
                    
                    if(self.data.count == 0) {
                        self.showNoDataMessage(tbView: self.tbView)
                    }
                    
                    if(response.pagination != nil && response.pagination?.totalPages != nil) {
                        let total = response.pagination?.totalRecords ?? 0
                        self.tfSearch.placeholder = "Tìm kiếm trong \(total) Công trình"
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
    
    
    @IBAction func projectMap(_ sender: Any) {
        let vc = MapViewController()
        vc.projects = data
        vc.isJustView = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func reloadData() {
        page = 0
        data.removeAll()
        getData()
    }
    
    @IBAction func filter(_ sender: Any) {

            let alert = UIAlertController(title: "Tùy chọn", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Tất cả", style: .default , handler:{ (UIAlertAction)in
                
                self.filterType = ""
                self.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Mới", style: .default , handler:{ (UIAlertAction)in
                self.filterType = "NEW"
                self.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Đang thi công", style: .default , handler:{ (UIAlertAction)in
                self.filterType = "PROCESSING"
                self.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Hoàn thành", style: .default , handler:{ (UIAlertAction)in
                self.filterType = "DONE"
                self.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Tạm dừng", style: .default , handler:{ (UIAlertAction)in
                self.filterType = "PAUSED"
                self.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
}

extension ListProjectViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if data.count > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        } else {
            //            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            //            noDataLabel.text          =  PopupMessages.nodata
            //            noDataLabel.textColor     = UIColor.init(hexString: HexColorApp.gray)
            //            noDataLabel.textAlignment = .center
            //            tableView.backgroundView  = noDataLabel
            //            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViewCell.identifier, for: indexPath) as! ProjectViewCell
        cell.setDataProject(data: data[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailProjectViewController") as? DetailProjectViewController {
            vc.project = data[indexPath.row]
            vc.id = data[indexPath.row].id!
            vc.ptitle = data[indexPath.row].name!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreControl.didScroll()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            removeTeamId = data[indexPath.row].id!
            showYesNoPopup(title: "Xác nhận", message: "Chắc chắn xóa?")
        }
    }
    
    func popupHandle() {
        
        noAction = {
            self.removeTeamId = 0
        }
        
        okAction = { [weak self] in
            self?.showLoading()
            APIClient.removeProject(id: self!.removeTeamId) { result in
                self?.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self?.showToast(content: "Thành công")
                        self?.data.removeAll()
                        self?.page = 0
                        self?.getData()
                    }
                    self?.showToast(content: response.message ?? "")
                    break
                    
                case .failure(let error):
                    self?.showToast(content: error.localizedDescription)
                }
            }
        }
        
    }
    
    
}

extension ListProjectViewController :UISearchBarDelegate  {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    
    
    
    
    //     func searchBar(_ searchBar: UISearchBar,
    //         selectedScopeButtonIndexDidChange selectedScope: Int) {
    //        textSearch = searchBar.text ?? ""
    //        page = 0
    //        data.removeAll()
    //        getData()
    //     }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        searchBar.resignFirstResponder()
        //        textSearch = searchBar.text ?? ""
        //            page = 0
        //            data.removeAll()
        //            getData()
    }
}




