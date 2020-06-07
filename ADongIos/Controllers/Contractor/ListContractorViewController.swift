//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ListContractorViewController: BaseViewController, UISearchBarDelegate, LoadMoreControlDelegate {
    

    var data = [Contractor]()
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var page = 0
    var totalPages = 0
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
        @IBOutlet weak var searchBar: UISearchBar!

    var loadMoreControl: LoadMoreControl!
    
    // For Adding To Team
    var isToChooseWorker = false
    var team:Team? = nil
    var chooseWorkerId = 0
    var workers = [Contractor]()
    var callback : ((Int?) -> Void)?
    
    var isCheckHiden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CommonNoAvatarCell.nib, forCellReuseIdentifier: CommonNoAvatarCell.identifier)
        
        loadMoreControl = LoadMoreControl(scrollView: tbView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreControl.delegate = self
        
        if(isToChooseWorker) {
            header.isRightButtonHide = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 0
        data.removeAll()
        getData()
    }
    

    
    func setupHeader() {
        header.title = "Nhà Thầu Phụ"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Contractor", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateContractorViewController") as? UpdateContractorViewController {
                vc.isUpdate = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func getData() {
        showLoading()
        APIClient.getContractors(page : page, name : searchBar.text ?? "") { result in
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

extension ListContractorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonNoAvatarCell.identifier, for: indexPath) as! CommonNoAvatarCell
        cell.setDataContractor(data: data[indexPath.row])
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isToChooseWorker) {
              workers.insert(data[indexPath.row], at: 0)
            showYesNoPopup(title: "Xác nhận", message: "Chọn Công nhân này?")
        } else {
            if let vc = UIStoryboard.init(name: "Contractor", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailContractorViewController") as? DetailContractorViewController {
                vc.id = data[indexPath.row].id!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreControl.didScroll()
    }
}

extension ListContractorViewController {
    
    func popupHandle() {
        okAction = {
 
        }
        
        noAction = {
      
        }
    }
}


