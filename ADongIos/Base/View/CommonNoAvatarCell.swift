//
//  CommonNoAvatarCell.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit


class CommonNoAvatarCell: UITableViewCell {
    
    @IBOutlet weak var lb1: UILabel!
    
    @IBOutlet weak var lb2: UILabel!
    
    @IBOutlet weak var lb3: UILabel!
    
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
    
    func setDataTrip(data:Transport) {
        lb1.text = data.code
        lb2.text = data.projectName
        if(data.projectAddress != nil && data.projectAddress != "") {
            lb3.text = data.projectAddress
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
        
        if(data.teamType != nil && data.teamType == "ADONG") {
            lb3.text = "Đội Á đông"
        } else {
            lb3.text = "Nhà thầu phụ"
        }
    }
    
 
}
