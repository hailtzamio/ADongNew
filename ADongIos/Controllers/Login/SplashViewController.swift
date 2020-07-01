//
//  SplashViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/19/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if let token =  self.preferences.object(forKey: accessToken) {
                Context.AccessToken = token as! String
                self.test()
            } else {
                self.test()
            }
        }
        
    }
    
    func goToLogin(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoNextPage(){
        let vc = PermissViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func test() {
        if let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainMapViewController") as? MainMapViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
