//
//  SmallInformationViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 6/3/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class SmallInformationViewCell: UITableViewCell {

    @IBOutlet weak var imvAva: UIImageView!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb1: UILabel!
    let imageDf = UIImage(named: "default")
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
    
    func setDataWorker(data:Worker) {
         lb1.text = data.fullName
         lb2.text = data.phone
        let url = URL(string: data.avatarUrl ?? "")
        
        imvAva.kf.setImage(with: url, placeholder: imageDf)
     }
    
    func setDataProduct(data:Product) {
          lb1.text = data.productName
        let qt = data.quantity ?? 0
        lb2.text = "\(qt) \(data.productUnit ?? "") \n\(data.note ?? "")"
     
      }
    
}
