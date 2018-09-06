//
//  LocationDataSource.swift
//  ukpd
//
//  Created by Alex Chesters on 05/09/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit

class LocationDataSource: NSObject, UITableViewDataSource {
    private var results: [Location] = []

    public func update(results: [Location]) {
        self.results = results
    }

    public func get(index: Int) -> Location {
        return self.results[index]
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let result = self.results[indexPath.row]

        cell.textLabel?.text = "\(result.name!) - \(result.area!)"

        cell.backgroundColor = Colors.main
        cell.textLabel?.textColor = .white

        return cell
    }
}
