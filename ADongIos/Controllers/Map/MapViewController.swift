//
//  MapViewController.swift
//  ADongIos
//
//  Created by Cuongvh on 6/10/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class MapViewController: BaseViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var imv1: UIImageView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lb1: UILabel!
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
        
        
        
        
        if(projects.count > 0) {
            
            lat = 21.0278
            long = 105.8342
            zoom = 5.0
            view1.isHidden = true
            imv1.isHidden = true
            projects.forEach { (project) in
                let marker = GMSMarker()

                
                if(project.status == "PROCESSING") {
                     marker.icon = UIImage(named: "green_dot")
                } else if(project.status == "NEW") {
                     marker.icon = UIImage(named: "dot_red_16")
                } else {
                
                }

                marker.setIconSize(scaledToSize: .init(width: 15, height:15))
                marker.position = CLLocationCoordinate2D(latitude: project.latitude ?? 0.0, longitude: project.longitude ?? 0.0)
                marker.title = project.name
                marker.snippet = project.address
                marker.map = mapView
                
            }
            
        } else {
            
            lat = data.latitude ?? 21.0278
            long = data.longitude ?? 105.8342
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.title = data.name
            marker.snippet = data.address
            marker.map = mapView
        }
        
        mapView.delegate = self
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: Float(zoom))
        mapView.camera = camera
        
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
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
}


extension MapViewController: CLLocationManagerDelegate {
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
            self.lb1.text = lines.joined(separator: "\n")
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
