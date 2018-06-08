//
//  ViewController.swift
//  map
//
//  Created by iOS Developer2 on 5/17/18.
//  Copyright © 2018 Amshuhu iTech Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //default location
//        let cameraLoc = GMSCameraPosition.camera(withLatitude: 32, longitude: 80.0, zoom: 6.0)
//        mapView.camera = cameraLoc
//        mapView.mapType = .normal
//        showMarker(position: cameraLoc.target)
        
        //getting current location
        let cameraLoc = GMSCameraPosition.camera(withLatitude: 37.778483, longitude: -122.513960, zoom: 17.0)
        self.mapView.camera = cameraLoc
        self.mapView?.isMyLocationEnabled = true

        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.delegate = self
        
       // drawRectange()
        //drawPolyLine()
        
        convertImg()
        
    }
    
    func showMarker(position: CLLocationCoordinate2D,addrs: String){
        let marker = GMSMarker()
        marker.position = position
        marker.title = addrs
        //marker.snippet = "San Francisco"
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //let location = locations.last
        
        // getting coordinates from current location
//        let latLong = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 20.0)
//        self.mapView?.animate(to: latLong)
//        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
//        self.showMarker(position: latLong.target)
        
        //convert address to location //geo coding
        
//        let address = "kundrathur,chennai - 69,Tamilnadu"
//
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(address) { (placemarks, error) in
//            guard
//                let placemarks = placemarks,
//                let location = placemarks.first?.location
//                else {
//                    // handle no location found
//                    return
//            }
//            // Use your location
//            let loc = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15.0)
//            self.mapView?.animate(to: loc)
//            self.locationManager.stopUpdatingLocation()
//            self.showMarker(position: loc.target,addrs: address)
//
//        }
    }
    
    func drawRectange(){
        /* create the path */
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
        
        /* show what you have drawn */
        let rectangle = GMSPolyline(path: path)
        rectangle.map = mapView
    }
    
    func drawPolyLine() {
        let position = CLLocationCoordinate2D(latitude: 37.778483, longitude: -122.513960)
        showMarker(position: position, addrs: "start")
        
        
        
        let origin = "\(37.778483),\(-122.513960)"
        let destination = "\(37.801945),\(-122.088787)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&modedriving&key"
       
        Alamofire.request(url).responseJSON { response in
            print(response)
            do {
                
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSMutablePath.init(fromEncodedPath: points!)
                    
                    
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = .red
                    polyline.strokeWidth = 5.0
                    polyline.map = self.mapView
                    
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title = "Hello World"
        marker.map = mapView
    }
    
    func convertImg() {
        let myImg = UIImage(named: "bg_eventbox.png")
        let dataImg: Data = UIImagePNGRepresentation(myImg!)!
        
        //let img = UIImage(data: dataImg)
        self.imgVw.image = UIImage(data: dataImg)
    }

   


}

