//
//  WareHouseViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 6/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class WareHouseViewCell: UITableViewCell {
    
    @IBOutlet weak var lb1: UILabel!
    
    @IBOutlet weak var lb2: UILabel!
    
    @IBOutlet weak var lb3: UILabel!
    
    @IBOutlet weak var lb4: UILabel!
    
    @IBOutlet weak var lb5: UILabel!
    
    
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
    
    func setData(data:Transport) {
        lb1.text = data.code ?? "---"
        lb2.text = data.warehouseName ?? "---"
        lb3.text = data.plannedDatetime ?? "---"
        var status = "Mới"
        if(data.status == 1) {
            status = "Mới"
        }
        
        if(data.status == 2) {
            status = "Đã hủy"
        }
        
        if(data.status == 3) {
            status = "Đã xong"
        }
        
        if(data.status == 4) {
            status = "Đã chọn xe"
        }
        
        if(data.status == 5) {
            status = "Đã nhận hàng"
        }
        
        lb4.text = data.projectName ?? "---"
        lb5.text = status
    }
    
    func setDataTrip(data:Trip) {
        lb1.text = data.code
        lb2.text = data.driverFullName ?? "---"
        lb3.text = data.driverPhone ?? "---"
        lb4.text = data.lorryPlateNumber ?? "---"
        lb5.text = data.plannedDatetime ?? "---"
    }
    
    func setDataGoodsReceivedNote(data:GoodsReceivedNote) {
        lb1.text = data.code
        lb2.text = data.deliveredBy ?? "---"
        lb3.text = data.note ?? "---"
        lb4.text = data.warehouseName ?? "---"
        
        if(data.status == "DONE") {
             lb5.text = "Hoàn thành"
        } else {
            lb5.text = "Nháp"
        }
        
       
    }
    
    
}
