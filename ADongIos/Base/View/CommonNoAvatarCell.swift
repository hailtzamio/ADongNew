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
    
    @IBOutlet weak var imv1: UIImageView!
    
    @IBOutlet weak var cons1: NSLayoutConstraint!
    
    
    @IBOutlet weak var cons2: NSLayoutConstraint!
    @IBOutlet weak var imvStatus: UIImageView!
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
        
        if(data.workingStatus == "idle") {
            if let image = UIImage(named: "free_dot") {
                imvStatus.image = image
            }
        } else {
            if let image = UIImage(named: "green_dot") {
                imvStatus.image = image
            }
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
        
        if(data.workingStatus == "idle") {
            if let image = UIImage(named: "free_dot") {
                imvStatus.image = image
            }
        } else {
            if let image = UIImage(named: "green_dot") {
                imvStatus.image = image
            }
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
    
    
    
    func setDataBidding(data:Contractor) {
        lb1.text = data.contractorName
        lb2.text = data.contractorPhone
        
        if(data.status == "REJECTED") {
            lb3.text = "Từ chối"
            lb3.textColor = UIColor.red
        } else if(data.status == "NEW") {
            lb3.text = "Mới"
            lb3.textColor = UIColor.init(hexString: HexColorApp.green)
        } else {
            lb3.text = "Đã duyệt"
            lb3.textColor = UIColor.init(hexString: HexColorApp.green)
        }
        
        if(data.workingStatus == "idle") {
            if let image = UIImage(named: "free_dot") {
                imvStatus.image = image
            }
        } else {
            if let image = UIImage(named: "green_dot") {
                imvStatus.image = image
            }
        }
    }
    
    func setDataNotification(data:NotificationOb) {
        lb1.text = data.title
//        lb1.text = data.objectType
        lb2.text = data.content
        
        if(data.seen ?? false) {
            lb3.text = "Đã đọc"
            lb3.textColor = UIColor.init(hexString: HexColorApp.green)
        } else {
            lb3.textColor = UIColor.init(hexString: HexColorApp.red)
            lb3.text = "Chưa đọc"
        }
        
    }
    
    func setDataLog(data:Log) {
        lb1.text = data.content ?? "---"
        lb2.text = data.userFullName ?? "---"
        lb3.text = "".convertDateFormatter(date: data.createdTime ?? "")
        
    }
    
    func setDataCheckOutIn(data:Worker) {
        lb1.text = data.workerFullName
        if(data.checkinTime == nil) {
            lb2.text = "Chưa điểm danh vào"
        } else {
            lb2.text = "".convertDateFormatter(date: data.checkinTime ?? "")
        }
        
        if(data.checkoutTime == nil) {
            lb3.text = "Chưa điểm danh ra"
        } else {
            lb3.text = "".convertDateFormatter(date: data.checkoutTime ?? "")
        }
        
        
    }
    
    
}
