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
    
    @IBOutlet weak var lb6: UILabel!
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
    
    func setDataProject(data:Project) {
        lb1.text = data.name
        lb2.text = data.address
        lb3.text = data.plannedStartDate
        lb4.text = data.plannedEndDate
        if(data.teamType != nil && data.teamType == "ADONG") {
            lb5.text = "Đội Á đông"
        } else {
            lb5.text = "Nhà thầu phụ"
        }
        
        switch data.status {
        case ProjectStatus.new:
            lb6.text = "Mới"
            lb6.textColor = UIColor.init(hexString: HexColorApp.red)
            break
        case ProjectStatus.processing:
            lb6.text = "Đang thi công"
                lb6.textColor = UIColor.init(hexString: HexColorApp.orange)
            break
        case ProjectStatus.done:
            lb6.text = "Hoàn thành"
                lb6.textColor = UIColor.init(hexString: HexColorApp.green)
            break
        case ProjectStatus.paused:
            lb6.text = "Tạm dừng"
              lb6.textColor = UIColor.init(hexString: HexColorApp.blue)
            break
        default:
            break
        }
        
        
        
    }
    
    
}
