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
    var hangouts = [Hangout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HangoutService.getUserHangouts { [unowned self] (hangouts) in
            self.hangouts = hangouts
            print(hangouts)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return hangouts.count
        return 10;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
//        configure(cell: cell, atIndexPath: indexPath)

        
        return cell
    }
    
//    func configure(cell: HomeTableViewCell, atIndexPath indexPath: IndexPath) {
//        let hangout = hangouts[indexPath.row]
//        cell.hangoutName.text = hangout.name
//    }
    
}
