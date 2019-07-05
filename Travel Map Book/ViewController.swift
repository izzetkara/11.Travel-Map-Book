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
    var requestCLLocation = CLLocation()
    
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    
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
        
        //Row a tiklaninda birsey var mi yok mu onu kontrol ardindan bilgileri gostermek.
        
        if selectedTitle != "" {
            
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: self.selectedLatitude, longitude: self.selectedLongitude)
            
            annotation.coordinate = coordinate
            annotation.title = self.selectedTitle
            annotation.subtitle = self.selectedSubtitle //self. eklemeyince de calisiyor gibi duruyor.
            self.mapView.addAnnotation(annotation)
            
            nameText.text = self.selectedTitle
            commentText.text = self.selectedSubtitle
            
        }
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //Asagida ne kadar zoom yapacagimizi belirtiyoruz.
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //Pinleri ozellestirmek
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if annotation is MKUserLocation {
            return nil //anotasyon kullanicinin kendi konumuyla alakali birseyse birsey yapma diyoruz eger degilse
        }
        
        let reuseID = "myAnnotation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true //Yuvarlak icinde i yazan bilgi butonu yarattik.
            pinView?.pinTintColor = UIColor.black // rengini sectik pinin
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure) //detaildisclosure butonun tipi.
            pinView?.rightCalloutAccessoryView = button // butonun turu.
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //righyCalloutAccesorrview e tiklaninca ne oldugunu yazicaz. Navigasyon yaraticaz.
        //buraya aktarilan enlem ve boylam var mi yok mu bos mu onu kontrol etmemeiz gerekiyor ilk once yoksa cokebilir.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if selectedLatitude != 0 {
            if selectedLongitude != 0 {
                //yuakrida requestCLLocation yarattik.
                self.requestCLLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
            }
        }
        //reverseGeocodeLocaiton olusturdugum enlem ve boylam dan adres bul demek.
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemark = placemarks {
                if placemark.count > 0 { // o adres var ise [0] ilk olanini aliyorum. o adrese giden bir navigasyon yaramtaya calisiyorum.
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.selectedTitle
                    
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
        
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
        
        //save butonuna basildiginda tableview a geri donmemiz icin gereken kodlari yaziyorum.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPlace"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
}

