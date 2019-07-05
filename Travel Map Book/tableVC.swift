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
    
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    

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
    @objc func fetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = (NSFetchRequest<NSFetchRequestResult>(entityName: "Places"))
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
    //Row secilince ne olacak onu yaziyorum.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = titleArray[indexPath.row]
        selectedSubtitle = subtitleArray[indexPath.row]
        selectedLatitude = latitudeArray[indexPath.row]
        selectedLongitude = longitudeArray[indexPath.row]
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    //Viewcontroller da yazilan notificationcenter i burada tamamliyorum.
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(tableVC.fetchData), name: NSNotification.Name("newPlace"), object: nil)
    }

    //prepare for segue yapmamiz gerekiyor. cunku viewconttoller deki degiskenler ile burada olusturdugumuz degiskenleri esitlemek icin.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = self.selectedTitle
            destinationVC.selectedSubtitle = self.selectedSubtitle
            destinationVC.selectedLatitude = self.selectedLatitude
            destinationVC.selectedLongitude = self.selectedLongitude
            
        }
    }
    

    @IBAction func addButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
}
