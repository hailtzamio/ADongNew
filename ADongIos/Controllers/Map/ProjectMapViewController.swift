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
class ProjectMapViewController: BaseViewController, GMSMapViewDelegate {
    

    @IBOutlet weak var mapView: GMSMapView!
    var isJustView = false
    var location = LocationAddress()
    private let locationManager = CLLocationManager()
    var callback : ((LocationAddress?) -> Void)?
    var lat = 0.0
    var long = 0.0
    var isCreateNewOne = false
    var zoom = 18.0
    var data = Project()
    var projects = [Project]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        
        
        
        
    }
    
    func setupView(){
        if(projects.count > 0) {
                lat = 17.787203
                  long = 105.605202
//         lat = 21.0278
//         long = 105.8342
         zoom = 5.5
    
         projects.forEach { (project) in
             let marker = GMSMarker()

             
             if(project.status == "PROCESSING") {
                  marker.icon = UIImage(named: "green_dot")
             } else if(project.status == "NEW") {
                  marker.icon = UIImage(named: "dot_red2")
                print("Come")
             } else {
             
             }
            
            var title = " \(project.address ?? "") \n \(project.plannedEndDate ?? "") \n \(project.plannedEndDate ?? "") \n \(project.teamName ?? "---") "

             marker.setIconSize(scaledToSize: .init(width: 12, height:12))
             marker.position = CLLocationCoordinate2D(latitude: project.latitude ?? 0.0, longitude: project.longitude ?? 0.0)
             marker.title = project.name
             marker.snippet = title
             marker.map = mapView
             
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
    
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {

        //you can handle zooming and camera update here
            print("Ahihi")
        
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
