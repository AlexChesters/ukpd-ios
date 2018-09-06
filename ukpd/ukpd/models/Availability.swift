//
//  SearchResult.swift
//  ukpd
//
//  Created by Alex Chesters on 28/08/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import Foundation

class Availability: NSObject {
    let date: String

    init(data: Dictionary<String, Any>) {
        self.date = data["date"] as! String
    }
}
