//
//  BaseViewController.swift
//  FastShare
//
//  Created by Fullname on 1/17/19.
//  Copyright © 2019 Fullname. All rights reserved.
//

import UIKit
import Toaster
import JGProgressHUD
import Alamofire
class BaseSearchViewController: UISearchController {
    
    let hud = JGProgressHUD(style: .dark)
    let preferences = UserDefaults.standard
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    var okAction: (() -> ())?
    var noAction: (() -> ())?
    var okActionInt : ((Int?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
//         self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    func showLoading()  {
        hud.show(in: self.view)
    }
    
    func stopLoading()  {
        hud.dismiss(afterDelay: 0.0)
    }
    
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func showToast(content:String){
        Toast(text: content, duration: Delay.short).show()
    }
    
//    func swipeToPop() {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
//    }
    
    func showAlert(message: String,
                   title: String? = "",
                   cancel: String = "Cancel",
                   otherButtons: [String] = [],
                   action: ((String) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { _ in
            action?(cancel)
        }))
        
        otherButtons.forEach { (title) in
            alertVC.addAction(UIAlertAction(title: title, style: .default, handler: { (alertAction) in
                action?(alertAction.title ?? "")
            }))
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func checkInternetConnection(){
        if !NetworkReachabilityManager()!.isReachable {
            showToast(content: error_check_internet)
            return
        }
    }
    
    func showYesNoPopup(title:String, message:String) {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
            self.okAction?()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: { (action: UIAlertAction!) in
            self.noAction?()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
}

extension BaseSearchViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
//     func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//           if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
//               navigationController?.popViewController(animated: true)
//           }
//           return false
//       }
    
    func showNoDataMessage(tbView : UITableView) {
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tbView.bounds.size.width, height: tbView.bounds.size.height))
        noDataLabel.text          =  PopupMessages.nodata
        noDataLabel.textColor     = UIColor.init(hexString: HexColorApp.gray)
        noDataLabel.textAlignment = .center
        tbView.backgroundView  = noDataLabel
        tbView.separatorStyle  = .none
    }
}


