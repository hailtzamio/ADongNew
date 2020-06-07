//
//  Switcher.swift
//  FastShare
//
//  Created by Tcsytems on 7/8/19.
//  Copyright © 2019 Fullname. All rights reserved.
//

import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let token = UserDefaults.standard.object(forKey: "accessToken")
        var rootVC : UIViewController?

            
        if(token != nil){
            rootVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        }else{
            // When Logout
            rootVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        
        let nav1 = UINavigationController()
        nav1.viewControllers = [rootVC] as! [UIViewController]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nav1
        appDelegate.window?.makeKeyAndVisible()
        
    }

}
