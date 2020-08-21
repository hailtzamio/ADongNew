//
//  MainMapViewController.swift
//  ADongIos
//
//  Created by Cuongvh on 8/9/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit

class MainMapViewController:UITabBarController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
