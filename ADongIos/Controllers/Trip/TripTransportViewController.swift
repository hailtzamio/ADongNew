//
//  ViewController.swift
//  PageMenuDemoStoryboard
//
//  Created by Niklas Fahl on 12/19/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

import UIKit

class TripTransportViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var id = 0
    var ptitle = "Vận Chuyển"
    var transports = [Transport]()
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var header: NavigationBar!
    override func viewDidLoad() {
        // MARK: - UI Setup
        header.title = ptitle
        header.isRightButtonHide = true
        
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
                // Create New Trip for transport
         
                   
                   let alert = UIAlertController(title: "Tùy chọn", message: "", preferredStyle: .actionSheet)
                   
                   alert.addAction(UIAlertAction(title: "Tạo mới", style: .default , handler:{ (UIAlertAction)in
                    self.goToCreateNewTrip()
                            
                   }))
                   
                   alert.addAction(UIAlertAction(title: "Có sẵn", style: .default , handler:{ (UIAlertAction)in
                        
                    
                    
                   }))
                   
            
                   alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler:{ (UIAlertAction)in
                       print("User click Dismiss button")
                   }))
                   
                   self.present(alert, animated: true, completion: {
                       print("completion block")
                   })
              
            
        }
        
        self.title = "PAGE MENU"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItem.Style.done, target: self, action: #selector(DetailProjectViewController.didTapGoToLeft))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItem.Style.done, target: self, action: #selector(DetailProjectViewController.didTapGoToRight))
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListTransportViewController") as? ListTransportViewController
        controller1!.title = "Yêu Cầu"
        controller1?.callbackRq = {(trans) in
        
            var isHide = true
            trans?.forEach { (trans) in
                if(trans.isSelected ?? false) {
                    self.transports.append(trans)
                    isHide = false
                }
            }
              self.header.isRightButton2Hide = isHide
        }

        controllerArray.append(controller1!)
        
        
        let controller2 = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListTripViewController") as? ListTripViewController
        controller2!.title = "Chuyến Đi"
        controller2?.callback = {(trip) in
            
         
                if let vc = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "TripDetailController") as? TripDetailController {
                                vc.id = trip?.id ?? 0
                                    self.navigationController?.pushViewController(vc, animated: true)
                   
            }
            
         
        }
        controllerArray.append(controller2!)
        
        
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.init(hexString: "#4c4c4c")),
            .viewBackgroundColor(UIColor.init(hexString: "#4c4c4c")),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 17.0)!),
            .menuHeight(40.0),
            //                  .menuItemWidth(90.0),
            .centerMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 70.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        
        self.contenView.addSubview(pageMenu!.view)
        self.pageMenu!.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        //              self.addChild(pageMenu!)
        //              self.view.addSubview(pageMenu!.view)
        //
        //              pageMenu!.didMove(toParent: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    @objc func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    // MARK: - Container View Controller
    
    //COULD NOT RESOLVE
    //	override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
    //		return true
    //	}
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
}

extension TripTransportViewController {

    func goToCreateNewTrip() {
    if let vc = UIStoryboard.init(name: "Trip", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateNewTripForTransportViewController") as? CreateNewTripForTransportViewController {
        vc.transports = transports
        navigationController?.pushViewController(vc, animated: true)
    }
    }
    
    
}






