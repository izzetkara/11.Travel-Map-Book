//
//  ViewController.swift
//  Travel Map Book
//
//  Created by İzzet Kara on 4.07.2019.
//  Copyright © 2019 Izzet Kara. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager() //Kullanicinin nerede oldugunu bulmaya calisicaz.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Best secercek en iyi sekilde konumu bulur fakat pil cok harcar.
        locationManager.requestWhenInUseAuthorization() // kullanildiginda konumu takip eder.
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //Asagida ne kadar zoom yapacagimizi belirtiyoruz.
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
}

