//
//  CountViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 6/12/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class CountViewCell: UITableViewCell {
    
    @IBOutlet weak var lb1: UILabel!
    
    @IBOutlet weak var lb2: UILabel!
    
    @IBOutlet weak var lb3: UILabel!
    
    @IBOutlet weak var tf1: UITextField!
    
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
    
    func setDataProduct(data:Product) {
        lb1.text = data.name
        lb2.text = data.createdByFullName
        lb3.text = data.updatedTime
        
        if(data.count != nil) {
            
            tf1.text = data.count
        } else {
            tf1.text = ""
        }
    }
    
}
