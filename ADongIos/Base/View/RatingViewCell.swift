//
//  RatingViewCell.swift
//  ADongIos
//
//  Created by Cuongvh on 7/24/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Cosmos
class RatingViewCell: UITableViewCell {

    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var view1: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        view1.settings.fillMode = .precise
    }
    
    static var nib:UINib {
         return UINib(nibName: identifier, bundle: nil)
     }
     
     static var identifier: String {
         return String(describing: self)
     }
    
    func setData(data:CriteriaMenu) {
         lb1.text = data.description
        view1.rating = data.score ?? 0.0
            lb2.text = String(data.score ?? 0.0)
        print(String(data.score ?? 0.0))
       
     }
    
    func setDataDetail(data:MarkSessionDetail) {
           lb1.text = data.criterionName ?? "---"
          view1.rating = data.point ?? 0.0
            lb2.text = String(data.point ?? 0.0)
          print(String(data.point ?? 0.0))
         
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
