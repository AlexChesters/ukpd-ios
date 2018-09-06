//
//  Location.swift
//  ukpd
//
//  Created by Alex Chesters on 29/08/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let name: String?
    let area: String?

    init(data: Dictionary<String, Any>) {
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
        self.name = data["name"] as? String
        self.area = data["local_government_area"] as? String
    }
}
