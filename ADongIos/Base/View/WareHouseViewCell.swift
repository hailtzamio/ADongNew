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
    
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var imv1: UIButton!
    var check:checkItem? = nil
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
        lb3.text = data.warehouseAddress ?? "---"
        var status = "Mới"
        if(data.status == 1) {
            status = "Mới"
            lb6.textColor = UIColor.init(hexString: HexColorApp.red)
        }
        
        if(data.status == 2) {
            status = "Đã hủy"
        }
        
        if(data.status == 3) {
            status = "Hoàn thành"
            lb6.textColor = UIColor.init(hexString: HexColorApp.orange)
        }
        
        if(data.status == 4) {
            status = "Đã ghép xe"
            lb6.textColor = UIColor.init(hexString: HexColorApp.green)
        }
        
        if(data.status == 5) {
            status = "Đã nhận hàng"
            lb6.textColor = UIColor.init(hexString: HexColorApp.green)
        }
        
        lb4.text = data.projectName ?? "---"
        lb5.text = data.projectAddress ?? "---"
        lb6.text = status
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
        lb2.text = data.ref ?? "---"
        lb3.text = data.deliveredBy ?? "---"
        lb4.text = data.warehouseName ?? "---"
         lb5.text = data.note ?? "---"
        if(data.status == "DONE") {
            lb6.textColor = UIColor.init(hexString: HexColorApp.green)
            lb6.text = "Hoàn thành"
        } else {
             lb6.textColor = UIColor.init(hexString: HexColorApp.red)
            lb6.text = "Nháp"
        }
        
        
    }
    
    
    
    func setDataGoodsIssue(data:GoodsIssue) {
        lb1.text = data.code
        lb2.text = data.warehouseName ?? "---"
        lb3.text = data.projectName ?? "---"
        lb4.text = data.projectAddress ?? "---"
         lb5.text = data.plannedDatetime ?? "---"
        if(data.status == 1) {
            lb6.textColor = UIColor.init(hexString: HexColorApp.green)
            lb6.text = "Hoàn thành"
        } else {
             lb6.textColor = UIColor.init(hexString: HexColorApp.red)
            lb6.text = "Nháp"
        }
    }
    
    @IBAction func check(_ sender: Any) {
        check?.doCheck(position: self.tag)
    }
    
    func setDataCheck(data:Transport) {
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
        lb5.text = data.projectAddress ?? "---"
        lb6.text = status
        
        if(data.isSelected ?? false) {
            if let image = UIImage(named: "tick2") {
                imv1.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: "round") {
                imv1.setImage(image, for: .normal)
            }
        }
    }
    
    
}
