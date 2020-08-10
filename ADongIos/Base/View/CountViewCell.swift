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
    
    
    @IBOutlet weak var tf1: UITextField!
    
    @IBOutlet weak var tf2: UITextField!
    
    var newText : ((_ text :String?, _ type: Int?)->())?
    @IBOutlet weak var imvAva: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tf1.delegate = self
        tf2.delegate = self
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
        
        let thumbnailUrl = data.thumbnailUrl ?? ""
        let url = URL(string: thumbnailUrl)
        imvAva.kf.setImage(with: url, placeholder: UIImage(named: "default"))
        
        //        switch data.type {
        //         case "buy":
        //             lb2.text = "Mua"
        //             break
        //             case "manufacture":
        //                        lb2.text = "Sản xuất"
        //                        break
        //             case "tool":
        //                        lb2.text = "Công cụ"
        //                        break
        //         default:
        //             break
        //         }
        
        if(data.count != nil) {
            
            tf1.text = data.count
        } else {
            tf1.text = ""
        }
    }
    
}

extension CountViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case tf1:
            break
        case tf2:
            break
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
      
        switch textField {
              case tf1:
                 newText!(updatedString, 1)
                  break
              case tf2:
                newText!(updatedString, 2)
                  break
              default:
                  break
              }
        return true
    }
    
}


