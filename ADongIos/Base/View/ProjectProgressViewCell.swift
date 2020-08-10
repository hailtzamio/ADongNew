//
//  ProjectProgressViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 6/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class ProjectProgressViewCell: UITableViewCell {
    
    @IBOutlet weak var imvNext: UIImageView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
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
    
    func setDataWorkOutline(data:ProgressProject) {
        lb1.text = data.workOutlineName ?? "---"
        if(data.finishDatetime != nil) {
            lb2.text = "".convertDateFormatter(date: data.finishDatetime ?? "")
            
            if let image = UIImage(named: "check_green") {
                imvAva.image = image
            }
            
            imvNext.isHidden = false
            
        } else {
            lb2.text = "Chưa hoàn thành"
            if let image = UIImage(named: "dot2") {
                imvAva.image = image
            }
            
             imvNext.isHidden = true
        }
        
        
        
    }
    
}
