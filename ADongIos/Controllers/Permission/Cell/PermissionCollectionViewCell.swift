//
//  PermissionCollectionViewCell.swift
//  ADongPr
//
//  Created by Cuongvh on 5/20/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class PermissionCollectionViewCell: UICollectionViewCell {
    
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
            title = "Vật Tư"
        }
        
        if(data.appEntityCode == "Contractor") {
            title = "Nhà Thầu Phụ"
        }
        
        if(data.appEntityCode == "Lorry") {
            title = "Xe"
        }
        
        if(data.appEntityCode == "Team") {
            title = "Đội Thi Công"
        }
        
        if(data.appEntityCode == "Project") {
            title = "Công Trình"
        }
        
        if(data.appEntityCode == "Driver") {
            title = "Lái Xe"
        }
        
        if(data.appEntityCode == "Worker") {
            title = "Công Nhân"
        }
        
        if(data.appEntityCode == "Transport") {
            title = "Vận Chuyển"
        }
        
        if(data.appEntityCode == "Trip") {
            title = "Chuyến Đi"
        }
        
        //        else {
        //            title = data.appEntityCode!
        //        }
        
        tbTitle.text = title
    }
    
}
