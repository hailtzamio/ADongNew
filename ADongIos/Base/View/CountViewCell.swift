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
    
    @IBOutlet weak var imvAva: UIImageView!
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

        lb3.text = data.unit ?? "---"
        
        let thumbnailUrl = data.thumbnailUrl ?? ""
        let url = URL(string: thumbnailUrl)
        imvAva.kf.setImage(with: url, placeholder: UIImage(named: "default"))
        
        switch data.type {
         case "buy":
             lb2.text = "Mua"
             break
             case "manufacture":
                        lb2.text = "Sản xuất"
                        break
             case "tool":
                        lb2.text = "Công cụ"
                        break
         default:
             break
         }
        
        if(data.count != nil) {
            
            tf1.text = data.count
        } else {
            tf1.text = ""
        }
    }
    
}
