//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ListTeamViewController: BaseViewController, UISearchBarDelegate, LoadMoreControlDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var data = [Team]()
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var page = 0
    var totalPages = 0
    
    var removeTeamId = 0
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var loadMoreControl: LoadMoreControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CommonNoAvatarCell.nib, forCellReuseIdentifier: CommonNoAvatarCell.identifier)
    
        loadMoreControl = LoadMoreControl(scrollView: tbView, spacingFromLastCell: 10, indicatorHeight: 60)
        loadMoreControl.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        page = 0
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Đội Thi Công"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
           if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateTeamViewController") as? UpdateTeamViewController {
                           vc.isUpdate = false
                           self.navigationController?.pushViewController(vc, animated: true)
           }
        }
    }
    
    func getData() {
        showLoading()
        APIClient.getTeams(page : page, name : searchBar.text ?? "") { result in
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

extension ListTeamViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonNoAvatarCell.identifier, for: indexPath) as! CommonNoAvatarCell
        cell.setDataTeam(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Team", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailTeamViewController") as? DetailTeamViewController {
            vc.id = data[indexPath.row].id!
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


