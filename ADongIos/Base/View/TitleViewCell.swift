//
//  TitleViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 6/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class TitleViewCell: UITableViewCell {
    
    @IBOutlet weak var imvAva: UIImageView!
    @IBOutlet weak var lb1: UILabel!
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
    
    func setData(data:TitleModel) {
        lb1.text = data.title
        if let image = UIImage(named: data.imagePath ?? "ava") {
            imvAva.image = image
        }
    }
    
}
