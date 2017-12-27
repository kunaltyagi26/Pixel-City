//
//  ViewController.swift
//  pixel-city
//
//  Created by Kunal Tyagi on 21/12/17.
//  Copyright © 2017 Kunal Tyagi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var startLocation: CLLocation?
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        //configureLocationServices()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//       print("I m being called")
//        centerMapOnUserLocation()
//    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        print("Latest location ", latestLocation)
        
        if startLocation == nil {
            startLocation = latestLocation
        }
        centerMapOnUserLocation()
        manager.stopUpdatingLocation()
    }
    
    @IBAction func centreMapBtnPressed(_ sender: Any)
    {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
        {
            centerMapOnUserLocation()
        }
        
        
    }
    
    func configureLocationServices()
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        if authorizationStatus == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        else
        {
            return
        }
    }
    
    func centerMapOnUserLocation(){
        guard let coordinate = startLocation?.coordinate else {
            print("Cant get the location coordinate.")
            return
            
        }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}

