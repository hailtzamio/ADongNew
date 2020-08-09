//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class StockTitlesViewController: BaseViewController {
    
    @IBOutlet weak var tbView: UITableView!
    var data = [TitleModel]()
    var callback : ((Int?) -> Void)?
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(TitleViewCell.nib, forCellReuseIdentifier: TitleViewCell.identifier)
        tbView.register(LineViewCell.nib, forCellReuseIdentifier: LineViewCell.identifier)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    
    func getData() {
        
        data.append(TitleModel(pTitle: "Danh sách kho", pImagePath: "factory"))
        data.append(TitleModel(pTitle: "line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Danh sách phiếu nhập kho", pImagePath: "import11"))
        data.append(TitleModel(pTitle: "Danh sách phiếu xuất kho", pImagePath: "export22"))
        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Danh sách yêu cầu xuất kho", pImagePath: "export11"))
        //        data.append(TitleModel(pTitle: "An toàn lao động", pImagePath: "hospital"))
        //        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        //        data.append(TitleModel(pTitle: "Thêm công nhân", pImagePath: "add_worker"))
        //        data.append(TitleModel(pTitle: "Kho ảnh", pImagePath: "picture"))
        //        data.append(TitleModel(pTitle: "Lịch sử điểm danh", pImagePath: "history"))
        //        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        //        data.append(TitleModel(pTitle: "Tạm dừng công trình", pImagePath: "burning"))
    }
    
}

extension StockTitlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 1 || indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineViewCell.identifier, for: indexPath) as! LineViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleViewCell.identifier, for: indexPath) as! TitleViewCell
            cell.setData(data: data[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback!(indexPath.row)
    }
}


