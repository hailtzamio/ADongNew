//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ListTripViewController : BaseViewController, UISearchBarDelegate, LoadMoreControlDelegate {
    
    var data = [Trip]()
      var callback : ((Trip?) -> Void)?
    var isChoose = false
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var page = 0
    var totalPages = 0
    
    var removeTeamId = 0
   
 @IBOutlet weak var tbView: UITableView!
    var loadMoreControl: LoadMoreControl!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(WareHouseViewCell.nib, forCellReuseIdentifier: WareHouseViewCell.identifier)
    
        loadMoreControl = LoadMoreControl(scrollView: tbView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreControl.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 0
        data.removeAll()
        getData()
    }
    
//    func setupHeader() {
//        header.title = "Đội Thi Công"
//        header.leftAction = {
//            self.navigationController?.popViewController(animated: true)
//        }
//
//        header.rightAction = {
//           if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateTeamViewController") as? UpdateTeamViewController {
//                           vc.isUpdate = false
//                           self.navigationController?.pushViewController(vc, animated: true)
//           }
//        }
//    }
    
    func getData() {
        showLoading()
        APIClient.getTrips(page : page, name : "", status: "") { result in
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

extension ListTripViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WareHouseViewCell.identifier, for: indexPath) as! WareHouseViewCell
        cell.setDataTrip(data: data[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             callback!(data[indexPath.row])
              goBack()
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
            APIClient.removeTeam(id: self!.removeTeamId) { result in
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


