//
//  tableVC.swift
//  Travel Map Book
//
//  Created by İzzet Kara on 5.07.2019.
//  Copyright © 2019 Izzet Kara. All rights reserved.
//

import UIKit
import CoreData

class tableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var titleArray = [String]()
    var subtitleArray = [String]()
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // fetch data yi koymayi unuttugum icin yazdigim kodlar gozukmedi!!
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    //Core datayi import ettik.Array leri tanimladik. Simdi veri cekicez coredataya.
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                self.titleArray.removeAll(keepingCapacity: false)
                self.subtitleArray.removeAll(keepingCapacity: false)
                self.latitudeArray.removeAll(keepingCapacity: false)
                self.longitudeArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                        
                    if let subtitle = result.value(forKey: "subtitle") as? String {
                        self.subtitleArray.append(subtitle)
                    if let latitude = result.value(forKey: "latitude") as? Double {
                        self.latitudeArray.append(latitude)
                    if let longitude = result.value(forKey: "longitude") as? Double {
                        self.longitudeArray.append(longitude)
                        }
        tableView.reloadData()
                    }
                }
            }
        }
    }
} catch {
            
            print("error")
            
        }
        
    }
    
    

    @IBAction func addButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
}
