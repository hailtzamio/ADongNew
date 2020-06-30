//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class FactoryTitlesViewController: BaseViewController {
    
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
        data.append(TitleModel(pTitle: "Danh sách xưởng", pImagePath: "burning"))
        data.append(TitleModel(pTitle: "line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Danh sách yêu cầu sản xuất", pImagePath: "print"))
        data.append(TitleModel(pTitle: "Danh sách phiếu xuất kho", pImagePath: "drawing"))
    }
    
}

extension FactoryTitlesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        switch indexPath.row {
        case 0:
            goToFatories()
            break
            case 2:
                  goToGoodsIssuesList()
                  break
        default:
            break
        }
    }
}

extension FactoryTitlesViewController {
    
    
    func goToFatories() {
        if let vc = UIStoryboard.init(name: "Warehouse", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListStockViewController") as? ListStockViewController {
            vc.id = id
            vc.titleHeader = "Xưởng"
            vc.type = "FACTORY"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToGoodsIssuesList() {
           if let vc = UIStoryboard.init(name: "Warehouse", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListGoodsIssueNoteViewController") as? ListGoodsIssueNoteViewController {
               vc.id = id
               vc.titleHeader = "Yêu Cầu Sản Xuất"
               navigationController?.pushViewController(vc, animated: true)
           }
       }
}
