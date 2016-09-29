//
//  MeetupAPI.swift
//  MyMeetups
//
//  Created by Dan Esrey on 2016/28/09.
//  Copyright © 2016 Dan Esrey. All rights reserved.
//

import Foundation
import CoreData

enum Method: String {
    case Cities = "/2/cities"
}

enum CityResult {
    case success ([City])
    case failure (Error)
}

enum MeetupError: Error {
    case invalidJSONData
}

class MeetupAPI {

    fileprivate class func meetupURL(method: Method,
                                     parameters: [String:String]?) -> URL {
        
        let bundle = Bundle.main
        guard let plistURL = bundle.url(forResource: "MeetupConfig", withExtension: "plist"),
            let plistData = try? Data(contentsOf: plistURL),
            let plist = (try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil)) as? [String:Any] else {
                fatalError("could not load MeetupConfig.plist")
        }
        
        let apiKey = plist["APIKey"] as? String
        let baseURLString = plist["BaseURL"] as? String
        
        let baseURL = URL(string: baseURLString!)!
        let methodURL = baseURL.appendingPathComponent(method.rawValue)
        var components = URLComponents(url: methodURL, resolvingAgainstBaseURL: true)
        
        var queryItems = [URLQueryItem]()

        let baseParams = [
            "format": "json",
            "nojsoncallback": "1",
            "key": apiKey,
            "sign": "true"
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components!.queryItems = queryItems
        
        return components!.url!
    }
    
    
    class func cityURL()->URL {
        return meetupURL(method: .Cities,
                         parameters: [:])
    }
    
    class func citiesFromJSONData(_ data: Data, inContext context: NSManagedObjectContext) -> CityResult {
        
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [String: [AnyObject]],
                let citiesArray = jsonDictionary["results"]! as? [AnyObject] else {
                    return .failure(MeetupError.invalidJSONData)
            }
            
            var finalCities = [City]()
            for cityJSON in citiesArray {
                if let city = cityFromJSONObject(cityJSON as! [String : AnyObject], inContext: context) {
                    finalCities.append(city)
                }
            }
            
            if finalCities.count == 0 && citiesArray.count > 0 {
                return .failure(MeetupError.invalidJSONData)
            }
            return .success(finalCities)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    fileprivate class func cityFromJSONObject(_ json: [String : AnyObject], inContext context: NSManagedObjectContext) -> City? {
        guard let
            name = json["name"] as? String else {
                return nil
        }
        let state = json["state"] as? String
        
        var city:City!
        context.performAndWait({ () -> Void in
            if #available(iOS 10.0, *) {
                city = City(entity: City.entity(),
                            insertInto: context)
            } else {
                city = NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City}
            city.name = name
            city.state = state
        })
        
        return  city
    }
    
}
