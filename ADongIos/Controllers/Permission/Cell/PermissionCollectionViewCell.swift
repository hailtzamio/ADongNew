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
            title = "Vat Tu"
        } else {
            title = data.appEntityCode!
        }
        
        tbTitle.text = title
    }

}
