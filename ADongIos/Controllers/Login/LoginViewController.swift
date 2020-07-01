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
    
    
    
    @IBOutlet weak var tf1: UITextField!
    
    @IBOutlet weak var tf2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf1.addPadding(.left(20.0))
        tf2.addPadding(.left(20.0))
        

        if let token =  preferences.object(forKey: accessToken) {
            Context.AccessToken = token as! String
                gotoNextPage()
        }
 
    }
    
    
    @IBAction func test(_ sender: Any) {
        K.ProductionServer.baseURL = "http://adong-api-test.zamio.net/api/"
        gotoNextPage()
    }
    
    @IBAction func login(_ sender: Any) {
        showLoading()
        APIClient.login(email: tf1.text ?? "", password: tf2.text ?? "") { result in
            
            self.stopLoading()
            switch result {
             
            case .success(let user):
                
                if(user.accessToken != nil) {
                    Context.AccessToken = user.accessToken ?? ""
                    self.gotoNextPage()
                    print(user.accessToken)
                    self.preferences.set(user.accessToken, forKey: accessToken)
                    self.preferences.set(user.fullName, forKey: fullName)
                } else {
                    self.showToast(content: "Sai tên đăng nhập hoặc mật khẩu")
                }
                
                print("_____________________________")
                //                ContentType.token = user.accessToken ?? ""
                
            case .failure(let error):
                print(error.localizedDescription)
                print(error.errorDescription)
            }
        }
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
//        let vc = PermissViewController()
//        navigationController?.pushViewController(vc, animated: true)
        
        if let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainMapViewController") as? MainMapViewController {
               navigationController?.pushViewController(vc, animated: true)
           }
    }
    
    
    
    
}
