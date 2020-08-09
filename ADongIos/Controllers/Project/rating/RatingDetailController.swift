//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

/// <#Description#>
class RatingDetailController: BaseViewController {
    
    var item = MarkSession()
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    var itemNames = ["THÔNG TIN CHUNG ", "CHI TIẾT ĐÁNH GIÁ"]
    
    
    @IBOutlet weak var btnPauseAndResume: UIButton!
    var id = 0
    var data = [Information]()
    var data1 = [MarkSessionDetail]()

 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()

        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        
         tbView.register(RatingViewCell.nib, forCellReuseIdentifier: RatingViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        data1.removeAll()
        getData()
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.isRightButtonHide = true

    }
    
    
    func getData() {
        self.data.removeAll()
        self.data1.removeAll()
        
        self.data1 = item.details ?? [MarkSessionDetail]()
        
        self.data.append(Information(pKey: "Loại tiêu chí",pValue: item.criteriaBundleName ?? ""))
        self.data.append(Information(pKey: "Công trình", pValue: item.projectName ?? ""))
        self.data.append(Information(pKey: "Ngày đánh giá", pValue: "".convertDateFormatter(date: item.createdTime ?? "2020-11-11T11:11:11")))
        
        tbView.reloadData()
    }
}

extension RatingDetailController: UITableViewDataSource, UITableViewDelegate {
    
    
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        sectionView.backgroundColor = UIColor.init(hexString: "#ffffff")
        
        let sectionName = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.size.width, height: 20))
        sectionName.text = itemNames[section]
        sectionName.textColor = UIColor.init(hexString: HexColorApp.orange)
        sectionName.font = UIFont.systemFont(ofSize: 17)
        sectionName.textAlignment = .left
        sectionName.font = UIFont.boldSystemFont(ofSize: 16)

        sectionView.addSubview(sectionName)
        return sectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return data.count
        case 1:
            return data1.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.imv1.isHidden = true
        
        switch (indexPath.section) {
        case 0:
            cell.setData(data: data[indexPath.row])
            if(indexPath.row == data.count - 1) {
                cell.line.isHidden = true
            }
            break
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingViewCell.identifier, for: indexPath) as! RatingViewCell
            cell.setDataDetail(data: data1[indexPath.row])
            return cell
            break
        default :
            break
        }
        return cell
    }
}
