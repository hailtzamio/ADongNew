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
        
        data.append(TitleModel(pTitle: "Thông tin cơ bản", pImagePath: "burning"))
        data.append(TitleModel(pTitle: "line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Danh sách vật tư", pImagePath: "print"))
        data.append(TitleModel(pTitle: "Bản thiết kế", pImagePath: "drawing"))
        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Đánh giá công trình", pImagePath: "healthcare"))
        data.append(TitleModel(pTitle: "An toàn lao động", pImagePath: "hospital"))
        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Thêm công nhân", pImagePath: "add_worker"))
        data.append(TitleModel(pTitle: "Kho ảnh", pImagePath: "picture"))
        data.append(TitleModel(pTitle: "Lịch sử điểm danh", pImagePath: "history"))
        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Tạm dừng công trình", pImagePath: "burning"))
    }
    
}

extension StockTitlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineViewCell.identifier, for: indexPath) as! LineViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleViewCell.identifier, for: indexPath) as! TitleViewCell
            cell.setData(data: data[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        switch indexPath.row {
        case 0:
            goToBaseInformation() 
            break
        default:
            break
        }
        
        
    }
}

extension StockTitlesViewController {


    func goToBaseInformation() {
                if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BaseInformationController") as? BaseInformationController {
                    vc.id = id
                    navigationController?.pushViewController(vc, animated: true)
                }
    }
}
