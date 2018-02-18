//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Chase on 28/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.shared.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = DataStorage.shared.students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = student.fullName
        cell.detailTextLabel?.text = student.mediaUrl
        return cell
    }
    
    // Get and URL from the selected row and try to open it
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openUrl(DataStorage.shared.students[indexPath.row].mediaUrl)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
}
