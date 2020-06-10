//
//  TransportViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 6/10/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class TransportViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imvAva: UIImageView!
    let imageDf = UIImage(named: "default")
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
    
    func setData(data:ImageModel){
        print(data.thumbnailUrl ?? "!!")
        let url = URL(string: data.thumbnailUrl ?? "")
        imvAva.kf.setImage(with: url, placeholder: imageDf)
    }
    
}
