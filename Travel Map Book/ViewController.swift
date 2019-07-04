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
import CoreData

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    
    
    var locationManager = CLLocationManager() //Kullanicinin nerede oldugunu bulmaya calisicaz.
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Best secercek en iyi sekilde konumu bulur fakat pil cok harcar.
        locationManager.requestWhenInUseAuthorization() // kullanildiginda konumu takip eder.
        locationManager.startUpdatingLocation()
       
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //Asagida ne kadar zoom yapacagimizi belirtiyoruz.
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //UILongpressgesturerecognizer icin fonksiyon
    
    @objc func chooseLocation (gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let chosenCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = chosenCoordinates.latitude
            chosenLongitude = chosenCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = chosenCoordinates
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            self.mapView.addAnnotation(annotation)
            
        }
        
        
        
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places" , into: context)
        
        newPlace.setValue(nameText.text, forKey: "title")
        newPlace.setValue(commentText.text, forKey: "subtitle")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        
        do {
            try context.save()
            print("Saved")
        } catch  {
            print("Error!")
        }
        
        
    }
    
    
}

