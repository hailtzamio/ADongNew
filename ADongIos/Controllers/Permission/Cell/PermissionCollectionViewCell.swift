//
//  PermissionCollectionViewCell.swift
//  ADongPr
//
//  Created by Cuongvh on 5/20/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class PermissionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imv1: UIImageView!
    @IBOutlet weak var tbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setData(data:Permission){
        
        var title = ""
        if(data.appEntityCode == "Product") {
            imv1.image = UIImage(named: "materials")
            title = "Vật Tư"
        }
        
        if(data.appEntityCode == "Contractor") {
             imv1.image = UIImage(named: "labor")
            title = "Nhà Thầu Phụ"
        }
        
        if(data.appEntityCode == "Lorry") {
             imv1.image = UIImage(named: "truck-1")
            title = "Xe"
        }
        
        if(data.appEntityCode == "Team") {
             imv1.image = UIImage(named: "team")
            title = "Đội Thi Công"
        }
        
        if(data.appEntityCode == "Project") {
             imv1.image = UIImage(named: "contruction")
            title = "Công Trình"
        }
        
        if(data.appEntityCode == "Driver") {
             imv1.image = UIImage(named: "steering")
            title = "Lái Xe"
        }
        
        if(data.appEntityCode == "Worker") {
             imv1.image = UIImage(named: "worker")
            title = "Công Nhân"
        }
        
        if(data.appEntityCode == "Transport") {
             imv1.image = UIImage(named: "labor")
            title = "Vận Chuyển"
        }
        
        if(data.appEntityCode == "Trip") {
             imv1.image = UIImage(named: "transport")
            title = "Chuyến Đi"
        }
        
        if(data.appEntityCode == "Warehouse") {
             imv1.image = UIImage(named: "labor")
            title = "Kho / Xưởng"
         }
        
        //        else {
        //            title = data.appEntityCode!
        //        }
        
        tbTitle.text = title
    }
    
}
