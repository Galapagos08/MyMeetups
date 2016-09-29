//
//  CityStore.swift
//  MyMeetups
//
//  Created by Dan Esrey on 2016/28/09.
//  Copyright © 2016 Dan Esrey. All rights reserved.
//

import UIKit
import CoreData

class CityStore {
    
    let coreDataStack = CoreDataStack(modelName: "MyMeetups")
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
 
    func processCitiesRequest(data: Data?, error: NSError?) -> CityResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return MeetupAPI.citiesFromJSONData(jsonData, inContext: self.coreDataStack.mainQueueContext)
    }
    
    
    func fetchCity (completion: @escaping (CityResult) -> Void ) {
        let url = MeetupAPI.cityURL()
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            let result = self.processCitiesRequest(data: data, error: error as NSError?)
            completion(result)
        })
        task.resume()
    }

}
