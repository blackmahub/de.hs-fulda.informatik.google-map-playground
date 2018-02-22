//
//  ViewController.swift
//  GoogleMapNavigationApp
//
//  Created by Mahbubur Rahman on 16.02.18.
//  Copyright © 2018 Mahbubur Rahman. All rights reserved.
//

import UIKit
//import CoreLocation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class ViewController: UIViewController { //, CLLocationManagerDelegate {

//    let locationManager = CLLocationManager()
    let universityCampusArea = CLLocationCoordinate2D(latitude: 50.5665016, longitude: 9.6855674)
    
//    var isRegionDefined  = false
    
    override func loadView() {
        
        let cameraPostion = GMSCameraPosition.camera(withLatitude: universityCampusArea.latitude, longitude: universityCampusArea.longitude, zoom: 18)
        let mapView = GMSMapView.map(withFrame: .zero, camera: cameraPostion)
        
        mapView.isIndoorEnabled = true
        mapView.isMyLocationEnabled = true
        
        self.view = mapView
        
        self.getDirectionFromGoogleMapAPI()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.activityType = CLActivityType.otherNavigation
//        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirectionFromGoogleMapAPI() {
        
        URLSession.shared.dataTask(with: URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood4&key=AIzaSyA5WKLZCTreqWGGVNdeucTzqCgsLfEf8CU")!) {

            (data, response, error) in

            print("\nJSON Response from Google Direction API:\n")
            print("\(data)\n")
        }.resume()
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let currentLocation = locations.last!
//
//        if !isRegionDefined {
//
//            let cameraPostion = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 18)
//            let mapView = GMSMapView.map(withFrame: .zero, camera: cameraPostion)
//
//            mapView.isMyLocationEnabled = true
//
//            self.view = mapView
//
//            isRegionDefined = true
//        }
//    }

}

struct GoogleDirection: Decodable {
    
    
    
}

struct GoogleRoute: Decodable {
    
    
    
}

struct GoogleLeg: Decodable {
    
    
    
}

struct GoogleStep: Decodable {
    
    
    
}


