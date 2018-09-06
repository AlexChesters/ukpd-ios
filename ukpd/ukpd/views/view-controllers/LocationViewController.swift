//
//  LocationViewController.swift
//  ukpd
//
//  Created by Alex Chesters on 04/09/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit
import Alamofire

class LocationViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!

    private let dataSource = LocationDataSource()
    private var results: [Location] = []
    private var selectedLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.main
        self.tableView.backgroundColor = Colors.main

        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self

        let recogniser = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        recogniser.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(recogniser)
        self.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func hideKeyboard() {
        self.textField.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchTerm = textField.text else { return }

        let url = "https://ukpd-locations-arwmnovnad.now.sh/towns/\(searchTerm)"

        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach { task in
                if url != task.originalRequest?.url?.absoluteString {
                    task.cancel()
                }
            }
        }
        Alamofire
         .request(url)
         .responseJSON(completionHandler: onLocationSuccess)
    }

    // MARK: - Network

    func onLocationSuccess(response: DataResponse<Any>) {
        guard let json = response.result.value else { return }
        let arr = json as! [Dictionary<String, Any>]
        let results = arr.map { raw -> Location in return Location(data: raw) }


        DispatchQueue.main.async {
            self.results = results
            self.dataSource.update(results: results)
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLocation = self.results[indexPath.row]
        self.performSegue(withIdentifier: "showStreetLevelResultsFromLocation", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showStreetLevelResultsFromLocation":
            let svc = segue.destination as! StreetLevelTableViewController
            svc.latitude = self.selectedLocation.latitude
            svc.longitude = self.selectedLocation.longitude
            svc.viewTitle = self.selectedLocation.name
        default:
            return
        }
    }

}
