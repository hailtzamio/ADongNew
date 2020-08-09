//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Cosmos
class RatingListViewController: BaseViewController {
    var data = [CriteriaMenu]()
    var markSessions = [MarkSession]()
    var id = 0
    
    @IBOutlet weak var view1: CosmosView!
    @IBOutlet weak var header: NavigationBar!
    @IBOutlet weak var tbView: UITableView!
    
    @IBOutlet weak var tv1: UILabel!
    var isToChoose = false
    var callback : ((Lorry?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(RatingViewCell.nib, forCellReuseIdentifier: RatingViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getMarksessions()
        getProject()
    }
    
    func setupHeader() {
        header.title = "Đánh Giá Công Trình"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true
        
        view1.settings.fillMode = .precise
    }
    
    func getMarksessions() {
        showLoading()
        APIClient.getMarkSessions(id : id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.markSessions = response.data!
                    self.getData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getProject() {
  
            APIClient.getProject(id: id) { result in
            
                switch result {
                case .success(let response):
                    
                    if let value = response.data  {
                        let rating = value.rating ?? 0.0
                        self.view1.rating = rating
                        self.tv1.text = String(rating)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    
    }
    
    func getData() {
        showLoading()
        APIClient.getSysparams { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    let tempData = response.data!
                    tempData.forEach { (criteriaMenu) in
                        if(criteriaMenu.value != nil) {
                            self.data.append(criteriaMenu)
                        }
                        
                    }
            
                    for i in 0..<self.data.count {
                        for j in 0..<self.markSessions.count {
                            if(self.markSessions[j].criteriaBundleId == Int(self.data[
                                i].value ?? "0")) {
                                self.data[i].score = self.markSessions[j].point
                            }
                        }
                    }
                    
                    self.tbView.reloadData()
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension RatingListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingViewCell.identifier, for: indexPath) as! RatingViewCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        markSessions.forEach { (markSession) in
            if(Int(data[indexPath.row].value ?? "0") == markSession.criteriaBundleId) {
                if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "RatingDetailController") as? RatingDetailController {
                    vc.item = markSession
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        
        
    }
}
