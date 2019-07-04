//
//  ViewController.swift
//  Travel Map Book
//
//  Created by İzzet Kara on 4.07.2019.
//  Copyright © 2019 Izzet Kara. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    
}

