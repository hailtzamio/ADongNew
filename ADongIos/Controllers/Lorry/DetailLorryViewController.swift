//
//  DetailLorryViewController.swift
//  ADongPr
//
//  Created by Cuongvh on 5/21/20.
//  Copyright © 2020 zamio. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class DetailLorryViewController: BaseViewController, GMSMapViewDelegate {
    var id = 0
    var item:Lorry? = nil
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var header: NavigationBar!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var data = [Information]()
    var lat = 0.0
    var long = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        popupHandle() 
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(InformationDetailCell.nib, forCellReuseIdentifier: InformationDetailCell.identifier)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data.removeAll()
        getData()
    }
    
    func setupView() {
        
        lat = item?.latitude ?? 0.0
        long = item?.longitude ?? 0.0
        
        let marker = GMSMarker()
        marker.icon = UIImage(named: "mover")
//        marker.setIconSize(scaledToSize: .init(width: 15, height:15))
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = item?.model ?? ""
        marker.snippet = item?.plateNumber ?? ""
        marker.map = mapView
        
        mapView.delegate = self
        
   
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: Float(5.0))
        mapView.camera = camera
        
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupHeader() {
        header.title = "Chi Tiết"
        header.leftAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.rightAction = {
            if let vc = UIStoryboard.init(name: "Lorry", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController {
                vc.data = self.item
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        header.changeUpdateIcon()
    }
    
    func popupHandle() {
        okAction = {
            self.showLoading()
            APIClient.removeLorry(id: self.id) { result in
                self.stopLoading()
                switch result {
                case .success(let response):
                    if (response.status == 1) {
                        self.goBack()
                    }
                    self.showToast(content: response.message ?? "")
                    break
                    
                case .failure(let error):
                    self.showToast(content: error.localizedDescription)
                }
            }
            
        }
        
    }
    
    func getData() {
        showLoading()
        APIClient.getLorry(id: id) { result in
            self.stopLoading()
            switch result {
            case .success(let response):
                
                if let value = response.data  {
                    self.item = value
                    self.data.append(Information(pKey: "Thương hiệu",pValue: value.brand ?? "---"))
                    self.data.append(Information(pKey: "Model",pValue: value.model ?? "---"))
                    self.data.append(Information(pKey: "Biển số xe",pValue: value.plateNumber ?? "---"))
                    if(value.capacity == "") {
                        value.capacity = nil
                    }
                    self.data.append(Information(pKey: "Trọng tải",pValue: value.capacity ?? "---"))
                    self.data.append(Information(pKey: "Địa chỉ",pValue: value.address ?? "---"))
                    self.tbView.reloadData()
                    
                    self.setupView()
                    return
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        showYesNoPopup(title: "Xóa", message: "Chắc chắn xóa?")
    }
}

extension DetailLorryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationDetailCell.identifier, for: indexPath) as! InformationDetailCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
}

extension DetailLorryViewController: CLLocationManagerDelegate {
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
     
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
