//
//  ViewController.swift
//  PlayWithMaps
//
//  Created by apple on 02/03/19.
//  Copyright © 2019 iOSProofs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var locationManger: CLLocationManager?
    var currentLocation: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLocationManager()
        requestUserPermissions()
        configureMapView()
    }
    
    func configureMapView() {
        mapView.showsUserLocation = true
        mapView.mapType = .standard
    }
    
    func requestUserPermissions() {
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied {            locationManger?.requestAlwaysAuthorization()
        }
    }
    
    func prepareLocationManager() {
        locationManger = CLLocationManager()
        locationManger?.delegate = self
        locationManger?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startObservingLocationChanges() {
        locationManger?.startUpdatingLocation()
    }
    
    func getAddressFromLatLong() {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.currentLocation!) { (placeMarks, error) in
            
            if let aPlaceMark = placeMarks?.first {
                print(aPlaceMark)
            }
        }
    }
    
    func addAnnotaiton() {
        let aAnnotation = MKPointAnnotation()
        aAnnotation.title = "ABC"
        aAnnotation.coordinate = currentLocation!.coordinate
        mapView.addAnnotation(aAnnotation)
    }
    
    func zoomToLocation() {
        let region = MKCoordinateRegion(center: currentLocation!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.region = region
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startObservingLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        print(currentLocation?.coordinate.latitude);
        print(currentLocation?.coordinate.longitude)
        
        if currentLocation != nil {
            locationManger?.stopUpdatingLocation()
            getAddressFromLatLong()
            zoomToLocation()
            addAnnotaiton()
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
}
