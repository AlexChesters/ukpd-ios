//
//  StreetLevelTableViewController.swift
//  ukpd
//
//  Created by Alex Chesters on 30/08/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit
import Alamofire

class StreetLevelTableViewController: UITableViewController {

    private let dataSource = StreetLevelDataSource()
    private var results: [StreetLevelCrime] = []
    private var categories: [String: String] = [:]
    private var selectedCrime: StreetLevelCrime?

    public var latitude: Double!
    public var longitude: Double!
    public var date: String?
    public var viewTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.navigationItem.title = self.viewTitle

        self.tableView.backgroundColor = Colors.main

        if let date = self.date {
            Alamofire
                .request("https://data.police.uk/api/crime-categories?date=\(date)")
                .responseJSON(completionHandler: onCategoriesSuccess)
        } else {
            Alamofire
                .request("https://data.police.uk/api/crime-categories")
                .responseJSON(completionHandler: onCategoriesSuccess)
        }
    }

    // MARK: - Network

    func onCategoriesSuccess(response: DataResponse<Any>) {
        guard let json = response.result.value else {
            return self.onError(error: "No JSON response received")
        }
        let arr = json as! [Dictionary<String, Any>]

        arr.forEach { categories[$0["url"] as! String] = $0["name"] as? String }

        if let date = self.date {
            Alamofire
                .request("https://data.police.uk/api/crimes-street/all-crime?lat=\(self.latitude!)&lng=\(self.longitude!)&date=\(date)")
                .responseJSON(completionHandler: onStreetLevelSuccess)
        } else {
            Alamofire
                .request("https://data.police.uk/api/crimes-street/all-crime?lat=\(self.latitude!)&lng=\(self.longitude!)")
                .responseJSON(completionHandler: onStreetLevelSuccess)
        }
    }

    func onStreetLevelSuccess(response: DataResponse<Any>) {
        guard let json = response.result.value else {
            return self.onError(error: "No JSON response received")
        }
        let arr = json as! [Dictionary<String, Any>]
        self.results = arr.map { raw -> StreetLevelCrime in return StreetLevelCrime(data: raw, categories: self.categories) }

        DispatchQueue.main.async {
            self.dataSource.update(results: self.results)
            self.tableView.reloadData()
        }
    }

    func onError(error: String) {
        ErrorDialog().showFor(view: self)
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCrime = self.results[indexPath.section]
        self.performSegue(withIdentifier: "showMap", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMap":
            let svc = segue.destination as! MapViewController
            svc.crime = self.selectedCrime
        default:
            return
        }
    }

}
