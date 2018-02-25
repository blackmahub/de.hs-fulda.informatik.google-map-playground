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
import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let universityCampusArea = CLLocationCoordinate2D(latitude: 50.5650077, longitude: 9.6853589)
    let centerLocationGeb46E = CLLocationCoordinate2D(latitude: 50.5650899, longitude: 9.6855439)
    let floor1Geb46E = UIImage(named: "E1.png")
    
    @IBOutlet weak var mapNavigationItem: UINavigationItem!
    @IBOutlet weak var mahbubView: UIView!
    
    
    
    var googleDirection: GoogleDirection? = nil
    
    override func loadView() {
    
        let cameraPostion = GMSCameraPosition.camera(withLatitude: universityCampusArea.latitude, longitude: universityCampusArea.longitude, zoom: 20) // 18
        let mapView = GMSMapView.map(withFrame: .zero, camera: cameraPostion)

        mapView.isMyLocationEnabled = true
        
        let groundOverlay = GMSGroundOverlay(position: centerLocationGeb46E, icon: floor1Geb46E, zoomLevel: CGFloat(19.7))
        groundOverlay.bearing = 30
        groundOverlay.map = mapView
        
//        let tileUrlConstructor: GMSTileURLConstructor = { x, y, zoom in
//
//            return Bundle.main.url(forResource: "E1", withExtension: "png")
//        }
        
//        let layer = GMSURLTileLayer(urlConstructor: tileUrlConstructor)
//        layer.map = mapView
        
//        let floors = ["Floor: 0", "Floor: 1", "Floor: 3"]
//        let floorSwitcher = UISegmentedControl(items: floors)
//        floorSwitcher.selectedSegmentIndex = 1
//        floorSwitcher.autoresizingMask = .flexibleWidth
//        floorSwitcher.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
//        floorSwitcher.addTarget(self, action: #selector(ViewController.drawFloorPlanOnMap(_:)), for: .valueChanged)
        
        self.view = mapView
        //print("Navigation Item from loadView: \(self.navigationItem)")
        //print("Navigation Item Title View from loadView: \(self.navigationItem.titleView)")
//        self.navigationItem.titleView = floorSwitcher
        
        let origin = CLLocationCoordinate2D(latitude: 50.5551995, longitude: 9.6793356) // my current location
        let destination = CLLocationCoordinate2D(latitude: 50.5639708, longitude: 9.6852563)
        self.getDirectionFromGoogleMapAPI(origin: origin, destination: destination)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.activityType = CLActivityType.otherNavigation
//        locationManager.distanceFilter = 100
//        locationManager.startUpdatingLocation()
        
//        print("Wifi SSID: \(self.getWiFiSsid())")
        
//        print("Navigation Item from viewDidLoad: \(self.navigationItem)")
//        print("Navigation Item Title View from viewDidLoad: \(self.navigationItem.titleView)")
        
        print("self.mapNavigationItem: \(self.mapNavigationItem)")
//        self.mapNavigationItem.titleView = UIImageView(image: UIImage(named: "Logo.png"))
//        self.view.bringSubview(toFront: self.mapNavigationItem.titleView!)
        
//        self.view.bringSubview(toFront: testButton)
        
//        let cameraPostion = GMSCameraPosition.camera(withLatitude: universityCampusArea.latitude, longitude: universityCampusArea.longitude, zoom: 20) // 18
//        let mapView = GMSMapView.map(withFrame: .zero, camera: cameraPostion)
//        self.mahbubView = mapView
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
                
                // inside university path
                path.add(CLLocationCoordinate2D(latitude: 50.5649110, longitude: 9.6860784))
                path.add(CLLocationCoordinate2D(latitude: 50.5649485, longitude: 9.6859888))
                
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor.purple
                polyline.map = self.view as! GMSMapView
            }
        }.resume()
    }
    
    func getWiFiSsid() -> String? {
        var ssid: String?
        print("Hello Mahbub: \(CNCopySupportedInterfaces())")
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    print("\(interfaceInfo)")
                    //                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    //                    break
                }
            }
        }
        return ssid
    }
    
    @IBAction func drawFloorPlanOnMap(_ sender: UISegmentedControl) {
        
        print("Current Floor: \(sender.titleForSegment(at: sender.selectedSegmentIndex))")
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


