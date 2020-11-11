//
//  ProjectMapViewController.swift
//  ADongIos
//
//  Created by Cuongvh on 7/1/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class ProjectMapViewController: BaseViewController, GMSMapViewDelegate, CAAnimationDelegate {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    var isJustView = false
    var location = LocationAddress()
    private let locationManager = CLLocationManager()
    var callback : ((LocationAddress?) -> Void)?
    var lat = 17.787203
    var long = 105.605202
    var isCreateNewOne = false
    var zoom = 5.0
    var data = Project()
    
    var projects = [Project]()
    var changeColor = true
    var globalMarker = GMSMarker()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(resetData), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        projects.removeAll()
        getData()
        //          self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func resetData() {
        projects.removeAll()
        getData()
    }
    
    func blinkMarker(marker: GMSMarker){
        let key = "blink"
        globalMarker = marker
        let pulseAnimation = CABasicAnimation(keyPath: "backgroundColor")
        pulseAnimation.delegate = self
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.repeatCount = HUGE
        pulseAnimation.autoreverses = true
        globalMarker.layer.add(pulseAnimation, forKey: key)
    }
    
    @objc func handleRegister(){
        print("!!!")
    }
    
    func setupView(){
        if(projects.count > 0) {
            lat = 17.787203
            long = 105.605202
            zoom = 5.5
            
            projects.forEach { (project) in
                let marker = GMSMarker()
                
                var title = " \(project.address ?? "") \n \(project.plannedEndDate ?? "") \n \(project.plannedEndDate ?? "") \n \(project.teamName ?? "---") "
                
                marker.setIconSize(scaledToSize: .init(width: 12, height:12))
                marker.position = CLLocationCoordinate2D(latitude: project.latitude ?? 0.0, longitude: project.longitude ?? 0.0)
                marker.title = project.name
                marker.snippet = title
                marker.map = mapView
                
                
                
                //                let uiButton = UIButton(frame: CGRect(x: 15, y: 5, width: 60, height: 20))
                //                uiButton.addTarget(self, action:#selector(handleRegister),
                //                                          for: .touchUpInside)
                //
                //                marker.iconView?.addSubview(uiButton)
                
                if(project.status != "DONE") {
                    
                    if(project.status == "PROCESSING") {
                        if(project.teamType == "ADONG") {
                            marker.iconView = UIImageView(image: UIImage(named: "greendot2"))
                        } else {
                            marker.iconView = UIImageView(image: UIImage(named: "dotblue"))
                        }
                        
                    } else if(project.status == "NEW") {
                        
                        marker.iconView = UIImageView(image: UIImage(named: "dotred2"))
                    } else {
                        
                        //                                    marker.iconView = UIImageView(image: UIImage(named: "dotred2"))
                    }
                    
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                        if(marker.iconView != nil) {
                            marker.iconView!.alpha = 0.0
                        }
                        
                    }, completion: nil)
                }
            }
        }
        
        mapView.delegate = self
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: Float(zoom))
        mapView.camera = camera
        
        
        //     mapView.isMyLocationEnabled = true
        //     mapView.settings.myLocationButton = true
        //     locationManager.delegate = self
        //     locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func goBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func chooseLocation(_ sender: Any) {
        if(!isJustView) {
            callback!(location)
        }
        
        goBack()
    }
    
    func getData() {
        showLoading()
        APIClient.getProjects(page : 0, name : "", status : "", size: 100) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if(response.data != nil) {
                    self.projects.append(contentsOf: response.data!)
                    self.setupView()
                    
                    
                } else {
                    self.showToast(content: response.message!)
                }
                
            case .failure(let error):
                self.showToast(content: error.localizedDescription)
            }
        }
        
    }
}

extension ProjectMapViewController: CLLocationManagerDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print(marker.position.latitude)
        projects.forEach { (project) in
            if(project.latitude ?? 0.0 == marker.position.latitude && project.longitude ?? 0.0 == marker.position.longitude) {
                if let vc = UIStoryboard.init(name: "Project", bundle: Bundle.main).instantiateViewController(withIdentifier: "BaseInformationController") as? BaseInformationController {
                    vc.project = project
                    vc.id = project.id!
                    vc.notificationType = "Show"
                    vc.hidesBottomBarWhenPushed = true
                    vc.isHideButtonRegister = true
                    navigationController?.pushViewController(vc, animated: true)
                }
                return
            }
        }
    }
    
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        
        //you can handle zooming and camera update here
        
        
        return true
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        
        print("didChangeAuthorization")
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("didUpdateLocations")
            
            return
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            self.lat = coordinate.latitude
            self.long = coordinate.longitude
            
            
            self.location.lat = coordinate.latitude
            self.location.long = coordinate.longitude
            self.location.name = lines.joined(separator: "\n")
            
            print(coordinate.latitude)
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
