//
//  InformationDetailCell.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class InformationDetailCell: UITableViewCell {
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
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
    
    func setData(data:Information) {
        lb1.text = data.value
        lb2.text = data.key
    }
    
    func setDataTest(data:String) {
        lb1.text = data
        lb2.text = "Ahihi"
    }
    
    func setDataProduct(data:Product) {
        lb1.text = data.productName ?? "---"
        lb2.text = String(describing: data.productUnit)
    }
    
    func setDataWareHouse(data:Warehouse) {
        lb1.text = data.name ?? "---"
        lb2.text = data.address ?? "---"
    }
    
    func setDataProductRequirement(data:GoodsReceivedNote) {
        lb1.text = data.code ?? "---"
        if(data.status == "NEW") {
            lb2.text = "Mới"
        }
        
    }
}
