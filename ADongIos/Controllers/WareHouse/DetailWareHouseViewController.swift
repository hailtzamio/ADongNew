//
//  ViewController.swift
//  PageMenuDemoStoryboard
//
//  Created by Niklas Fahl on 12/19/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

import UIKit

class DetailWareHouseViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var id = 0
    var ptitle = "Kho / Xưởng"
    
   
    
     @IBOutlet weak var header: NavigationBar!
    override func viewDidLoad() {
        // MARK: - UI Setup
              header.title = ptitle
              header.isRightButtonHide = true
              
              header.leftAction = {
                       self.navigationController?.popViewController(animated: true)
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
              
              let controller1 = UIStoryboard.init(name: "Warehouse", bundle: Bundle.main).instantiateViewController(withIdentifier: "StockTitlesViewController") as? StockTitlesViewController
              controller1!.title = "Kho"
              controller1?.id = id
              controllerArray.append(controller1!)
              
              
              let controller2 = UIStoryboard.init(name: "Warehouse", bundle: Bundle.main).instantiateViewController(withIdentifier: "FactoryTitlesViewController") as? FactoryTitlesViewController
              controller2!.title = "Xưởng"
                    controller2?.id = id
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

              self.addChild(pageMenu!)
              self.view.addSubview(pageMenu!.view)
              
              pageMenu!.didMove(toParent: self)
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


