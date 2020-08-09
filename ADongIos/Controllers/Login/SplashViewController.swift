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
                
                if let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainMapViewController") as? MainMapViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    let nav1 = UINavigationController()
                    nav1.viewControllers = [vc] as! [UIViewController]
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = nav1
                    appDelegate.window?.makeKeyAndVisible()
                    
                }
                
//                self.test()
            } else {
                self.goToLogin()
            }
        }
        
        
        //        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //        let documentsDirectory = paths[0]
        //        let docURL = URL(string: documentsDirectory)!
        //        let dataPath = docURL.appendingPathComponent("Hair")
        //        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
        //            do {
        //                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
        //            } catch {
        //                print(error.localizedDescription);
        //            }
        //        }
        
        //        print(dataPath)
        
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "png" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)
            
        } catch {
            print(error)
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
    
    //    func test() {
    //        if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "DownloadController") as? DownloadController {
    //            navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
