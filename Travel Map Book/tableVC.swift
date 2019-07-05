//
//  tableVC.swift
//  Travel Map Book
//
//  Created by İzzet Kara on 5.07.2019.
//  Copyright © 2019 Izzet Kara. All rights reserved.
//

import UIKit

class tableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }

    @IBAction func addButtonClicked(_ sender: Any) {
    }
    
}
