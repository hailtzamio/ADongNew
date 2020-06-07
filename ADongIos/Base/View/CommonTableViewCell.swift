//
//  CommonTableViewCell.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Kingfisher

protocol checkItem {
    func doCheck(position:Int)
}

class CommonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvCheck: UIButton!
    @IBOutlet weak var lb1: UILabel!
    
    @IBOutlet weak var lb2: UILabel!
    
    @IBOutlet weak var lb3: UILabel!
    
    @IBOutlet weak var imvAva: UIImageView!
    
    var check:checkItem? = nil
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
    
    
    @IBAction func check(_ sender: Any) {
        check?.doCheck(position: self.tag)
    }
    
    func setData(data:Lorry) {
        lb1.text = data.model
        lb2.text = data.brand
        lb3.text = data.plateNumber
    }
    
    func setDataProduct(data:Product) {
        lb1.text = data.name
        lb2.text = data.createdByFullName
        lb3.text = data.updatedTime
    }
    
    func setDataWorker(data:Worker) {
        lb1.text = data.userFullName
        if(data.isTeamLeader ?? false) {
            lb2.text = "Đội trưởng"
        } else {
            lb2.text = "Công nhân"
        }
        lb3.text = data.phone
        let url = URL(string: data.avatarUrl ?? "")
        
        imvAva.kf.setImage(with: url, placeholder: imageDf)
        
        if data.isSelected ?? false {
            if let image = UIImage(named: "correct") {
                imvCheck.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: "truck") {
                imvCheck.setImage(image, for: .normal)
            }
        }
    }
    
    func setDataWorkerCheck(data:Worker) {
        lb1.text = data.userFullName
        if(data.isTeamLeader ?? false) {
            lb2.text = "Đội trưởng"
        } else {
            lb2.text = "Công nhân"
        }
        lb3.text = data.phone
        let url = URL(string: data.avatarUrl ?? "")
        
        imvAva.kf.setImage(with: url, placeholder: imageDf)
        
        
        if data.isSelected ?? false {
            if let image = UIImage(named: "Checkmark") {
                imvCheck.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: "Checkmarkempty") {
                imvCheck.setImage(image, for: .normal)
            }
        }
    }
    
    func setDataTest(data:String) {
        lb1.text = data
        lb2.text = "Ahihi"
    }
    
    func setDataDriver(data:Driver) {
        lb1.text = data.fullName
        lb2.text = data.phone
    
        if(data.tripName != nil && data.tripName != "") {
            lb3.text = data.email ?? "---"
        }
        
        let url = URL(string: data.avatarUrl ?? "")
        imvAva.kf.setImage(with: url, placeholder: imageDf)
    }
    
}
