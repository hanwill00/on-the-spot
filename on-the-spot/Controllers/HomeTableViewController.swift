//
//  HomeViewController.swift
//  on-the-spot
//
//  Created by William Han on 7/24/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
        cell.textLabel?.text = "Cell Row: \(indexPath.row) Section: \(indexPath.section)"
        
        return cell
    }
    
}
