//
//  ViewController.swift
//  GoogleMapNavigationApp
//
//  Created by Mahbubur Rahman on 16.02.18.
//  Copyright © 2018 Mahbubur Rahman. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let universityCampusArea = CLLocationCoordinate2D(latitude: 50.5665016, longitude: 9.6855674)
    
    var googleDirection: GoogleDirection? = nil
    
    override func loadView() {
        
        let cameraPostion = GMSCameraPosition.camera(withLatitude: universityCampusArea.latitude, longitude: universityCampusArea.longitude, zoom: 18)
        let mapView = GMSMapView.map(withFrame: .zero, camera: cameraPostion)

        mapView.isMyLocationEnabled = true
        
        
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!
        print("\nMy Location from location manager: \(currentLocation)\n")
        
//        let cameraPostion = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 18)
//
//        let mapView = GMSMapView.map(withFrame: .zero, camera: cameraPostion)
//        mapView.isMyLocationEnabled = true
//
//        self.view = mapView
        
        let origin = currentLocation.coordinate
        let destination = CLLocationCoordinate2D(latitude: 50.5551995, longitude: 9.6793356)
        self.getDirectionFromGoogleMapAPI(origin: origin, destination: destination)
    }
    
    func getDirectionFromGoogleMapAPI(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&key=AIzaSyA5WKLZCTreqWGGVNdeucTzqCgsLfEf8CU&mode=walking")!
        
        print("\nURL: \(url)\n")
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            print("\nJSON Response from Google Direction API:\n")
            print("\(data)\n")
            
            guard let directionData = data else {
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    self.googleDirection = try JSONDecoder().decode(GoogleDirection.self, from: directionData)
                    print("After Decode: \(self.googleDirection)\n")
                } catch let jsonError {
                    print("\nJSON Error: " + jsonError.localizedDescription + "\n")
                }
                
                guard self.googleDirection != nil,
                    "OK" == self.googleDirection!.status else {
                        
                        return
                }
                
                print("\nCreating GMS Path ...\n")
                let steps = self.googleDirection!.routes.flatMap({ $0.legs.flatMap({ $0.steps }) })
                print("\nSteps: \(steps)\n")
                
                let path = GMSMutablePath()
                steps.forEach { step in
                    
                    path.add(CLLocationCoordinate2D(latitude: step.start_location.lat, longitude: step.start_location.lng))
                    path.add(CLLocationCoordinate2D(latitude: step.end_location.lat, longitude: step.end_location.lng))
                }
                
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor.purple
                polyline.map = self.view as! GMSMapView
            }
        }.resume()
    }
    
}

struct GoogleDirection: Decodable {
    
    var routes: [GoogleRoute]
    var status: String
}

struct GoogleRoute: Decodable {
    
    var legs: [GoogleLeg]
    
}

struct GoogleLeg: Decodable {
    
    var steps: [GoogleStep]
    
}

struct GoogleStep: Decodable {
    
    var start_location: GoogleLocation
    var end_location: GoogleLocation
    
}

struct GoogleLocation: Decodable {
    
    var lat: Double
    var lng: Double
    
}


