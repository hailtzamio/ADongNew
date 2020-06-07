//
//  LoginViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/19/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func test(_ sender: Any) {
        K.ProductionServer.baseURL = "http://adong-api-test.zamio.net/api/"
        gotoNextPage()
    }
    
    @IBAction func login(_ sender: Any) {
                gotoNextPage()
//        APIClient.login(email: "admin", password: "123456") { result in
//            switch result {
//            case .success(let user):
//                print("_____________________________")
//                print(user.accessToken)
//                self.preferences.set(user.accessToken, forKey: accessToken)
//                self.preferences.set(user.fullName, forKey: fullName)
//            case .failure(let error):
//                print(error.localizedDescription)
//                print(error.errorDescription)
//            }
//        }
    }
    
    func demoGetList() {
        APIClient.getPermissions{ result in
            switch result {
            case .success(let articles):
                print("_____________________________")
            //                print(articles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func gotoNextPage(){
        let vc = PermissViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
