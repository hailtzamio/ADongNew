//
//  LorryListViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class InformationListViewController: BaseViewController {
    
    @IBOutlet weak var tbView: UITableView!
    var data = [TitleModel]()
    var project = Project()
    var id = 0
    var callback : ((TitleModel?) -> Void)?
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
        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        if(project.teamType != "ADONG") {
            data.append(TitleModel(pTitle: "Danh sách đăng ký thi công", pImagePath: "regpro2"))
        } else {
            data.append(TitleModel(pTitle: "Thêm công nhân", pImagePath: "add_worker"))
        }
        data.append(TitleModel(pTitle: "Danh sách yêu cầu vật tư", pImagePath: "print"))
        data.append(TitleModel(pTitle: "Bản thiết kế", pImagePath: "drawing"))
        data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
        data.append(TitleModel(pTitle: "Đánh giá công trình", pImagePath: "healthcare"))
        
        
        if(project.teamType == "ADONG") {
            data.append(TitleModel(pTitle: "Line", pImagePath: "check_green"))
            
            data.append(TitleModel(pTitle: "Kho ảnh", pImagePath: "picture"))
            data.append(TitleModel(pTitle: "Lịch sử điểm danh", pImagePath: "history"))
        }
        
        data.append(TitleModel(pTitle: "Lịch sử thay đổi", pImagePath: "change_icon"))

        data.append(TitleModel(pTitle: "Báo cáo", pImagePath: "report_icon"))
    }
    
}

extension InformationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if data[indexPath.row].title == "Line" {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineViewCell.identifier, for: indexPath) as! LineViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleViewCell.identifier, for: indexPath) as! TitleViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setData(data: data[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback!(data[indexPath.row])
        //        switch indexPath.row {
        //        case 0:
        //            goToBaseInformation()
        //            break
        //        case 2:
        //            goToProjectBidding()
        //            break
        //        case 3:
        //            goToProductRequirement()
        //            break
        //        case 4:
        //            goToFiles()
        //            break
        //        case 9:
        //            goToChooseWorker()
        //            break
        //        case 11:
        //            goToCheckinOutList()
        //            break
        //            case 10:
        //                goToAlbum()
        //                break
        //        default:
        //            break
        //        }
        
        
    }
}

extension InformationListViewController {
    
    
    func goToBaseInformation() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BaseInformationController") as? BaseInformationController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToProductRequirement() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductRequirementViewController") as? ProductRequirementViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func goToProjectBidding() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BiddingListViewController") as? BiddingListViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToChooseWorker() {
        if let vc = UIStoryboard.init(name: "Worker", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListWorkerViewController") as? ListWorkerViewController {
            vc.isToChooseWorker = true
            vc.isAddWorkerToProject = true
            vc.projectId = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToCheckinOutList() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckinOutListViewController") as? CheckinOutListViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToAlbum() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProjectImagesViewController") as? ProjectImagesViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToFiles() {
        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileListViewController") as? FileListViewController {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
