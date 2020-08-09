//
//  ProjectViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 6/8/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ProjectViewCell: UITableViewCell {
    
    @IBOutlet weak var lb1: UILabel!
    
    @IBOutlet weak var lb2: UILabel!
    
    @IBOutlet weak var lb3: UILabel!
    
    @IBOutlet weak var lb4: UILabel!
    
    @IBOutlet weak var lb5: UILabel!
    
    
    @IBOutlet weak var bt1: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setData(data:Lorry) {
        lb1.text = data.brand
        lb2.text = data.model
        lb3.text = data.plateNumber
    }
    
    func setDataTeam(data:Team) {
        lb1.text = data.name
        lb2.text = data.phone
        if(data.address != nil && data.address != "") {
            lb3.text = data.address
        }
    }
    
    func setDataContractor(data:Contractor) {
        lb1.text = data.name
        lb2.text = data.phone
        
        if(data.address != nil && data.address != "") {
            lb3.text = data.address
        }
    }
    
    func setDataRegistration(data:Project) {
           lb1.text = data.projectName
           lb2.text = data.projectAddress
           lb3.text = "".convertDateFormatter(date: data.plannedStartDate ?? "")
           lb4.text = "".convertDateFormatter(date: data.plannedEndDate ?? "")
           lb5.text = data.secretaryFullName
           
           bt1.setTitle("Đấu thầu", for: .normal)
                    bt1.backgroundColor = UIColor.init(hexString: HexColorApp.red)
       }
    
    func setDataProject(data:Project) {
        lb1.text = data.name
        lb2.text = data.address
        lb3.text = data.plannedStartDate
        lb3.text = "".convertDateFormatter(date: data.plannedStartDate ?? "")
        lb4.text = "".convertDateFormatter(date: data.plannedEndDate ?? "")
        if(data.teamType != nil && data.teamType == "ADONG") {
            lb5.text = "Đội Á đông"
        } else {
            lb5.text = "Nhà thầu phụ"
        }
        
        switch data.status {
        case ProjectStatus.new:
            bt1.setTitle("Mới", for: .normal)
            bt1.backgroundColor = UIColor.init(hexString: HexColorApp.red)
            break
        case ProjectStatus.processing:
            bt1.setTitle("Đang thi công", for: .normal)
            bt1.backgroundColor = UIColor.init(hexString: HexColorApp.green)
            break
        case ProjectStatus.done:
            bt1.setTitle("Hoàn thành", for: .normal)
            bt1.backgroundColor = UIColor.init(hexString: HexColorApp.orange)
            break
        case ProjectStatus.paused:
            bt1.setTitle("Tạm dừng", for: .normal)
            bt1.backgroundColor = UIColor.init(hexString: HexColorApp.blue)
            break
        default:
            break
        }
    }
    
    
}
