//
//  SplashViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/19/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class SplashViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }

    func gotoNextPage(){
               let vc = LoginViewController()
               navigationController?.pushViewController(vc, animated: true)
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
