//
//  StreetLevelCrime.swift
//  ukpd
//
//  Created by Alex Chesters on 30/08/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit

class StreetLevelCrime: NSObject {
    let location: String
    let category: String
    let latitude: Double
    let longitude: Double
    let outcome: String?

    init(data: Dictionary<String, Any>, categories: [String: String]) {
        let locationDict = data["location"] as! Dictionary<String, Any>
        let streetDict = locationDict["street"] as! Dictionary<String, Any>
        if let outcomeDict = data["outcome_status"] as? Dictionary<String, Any> {
            self.outcome = outcomeDict["category"] as? String
        } else {
            self.outcome = nil
        }

        let categoryId = data["category"] as! String

        self.location = streetDict["name"] as! String
        self.category = categories[categoryId]!
        self.latitude = Double(locationDict["latitude"] as! String)!
        self.longitude = Double(locationDict["longitude"] as! String)!
    }
}
