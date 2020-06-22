//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class CheckinOutListViewController: BaseViewController {
    
    var data = [Worker]()
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(CommonNoAvatarCell.nib, forCellReuseIdentifier: CommonNoAvatarCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Lịch Sử Điểm Danh"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
    }
    
    func getData() {
        showLoading()
        APIClient.getProjectCheckOut(id : id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.data = response.data!
                    self.tbView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension CheckinOutListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonNoAvatarCell.identifier, for: indexPath) as! CommonNoAvatarCell
        cell.imv1.isHidden = true
       cell.cons2.constant = 0
        cell.cons1.constant = 0
        cell.setDataCheckOutIn(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
