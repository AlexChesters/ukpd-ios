//
//  StreetLevelDataSource.swift
//  ukpd
//
//  Created by Alex Chesters on 30/08/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import Foundation
import UIKit

class StreetLevelDataSource: NSObject, UITableViewDataSource {
    private var results: [StreetLevelCrime] = []

    public func update(results: [StreetLevelCrime]) {
        self.results = results
    }

    public func get(index: Int) -> StreetLevelCrime {
        return self.results[index]
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.results.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let result = self.results[section]
        return result.location
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StreetLevelTableViewCell

        let result = self.results[indexPath.section]

        cell.categoryLabel.text = "Category: \(result.category)"
        if let outcome = result.outcome {
            cell.outcomeLabel.text = "Outcome: \(outcome)"
        } else {
            cell.outcomeLabel.text = "Outcome: N/A"
        }

        cell.backgroundColor = Colors.main

        cell.categoryTitleLabel.textColor = .white
        cell.categoryLabel.textColor = .white
        cell.outcomeTitleLabel.textColor = .white
        cell.outcomeLabel.textColor = .white

        return cell
    }
}
