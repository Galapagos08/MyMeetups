//
//  ViewController.swift
//  MyMeetups
//
//  Created by Dan Esrey on 2016/28/09.
//  Copyright © 2016 Dan Esrey. All rights reserved.
//

import UIKit

class CitiesViewController: UITableViewController {
    
    var cities: [City] = []
    var cityStore: CityStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
        cityStore.fetchCity{
            (citiesResult) -> Void in
            
            switch citiesResult {
            case let .success(cities):
                print("Successfully found \(cities.count) cities.")
                
                OperationQueue.main.addOperation {
                    self.cities = cities
                    self.tableView.reloadData()
                }
                
            case let .failure(error):
                print("Error fetching cities: \(error)")
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let city = cities[(indexPath as NSIndexPath).row]
        
        cell.cityLabel.text = city.name
        cell.stateLabel.text = city.state
        
        return cell
    }
    
}

