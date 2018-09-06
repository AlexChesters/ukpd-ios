//
//  StreetLevelViewController.swift
//  ukpd
//
//  Created by Alex Chesters on 29/08/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class StreetLevelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    private var availabilityResults: [Availability] = []
    private var streetLevelResults: [StreetLevelCrime] = []
    private var latitude: Double!
    private var longitude: Double!
    private var postcode: String?

    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var useMyLocationButton: UIButton!
    @IBOutlet weak var browseByLocationButton: UIButton!
    @IBOutlet weak var datePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePickerView.delegate = self
        self.locationManager.delegate = self

        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

        self.searchButton.addTarget(self, action: #selector(onSearchSelected), for: .touchUpInside)
        self.useMyLocationButton.addTarget(self, action: #selector(onUseMyLocationSelected), for: .touchUpInside)
        self.browseByLocationButton.addTarget(self, action: #selector(onBrowseByLocationSelected), for: .touchUpInside)
        configureButton(button: self.searchButton)
        configureButton(button: self.useMyLocationButton)
        configureButton(button: self.browseByLocationButton)

        self.view.backgroundColor = Colors.main

        Alamofire
            .request("https://data.police.uk/api/crimes-street-dates")
            .responseJSON(completionHandler: onAvailabilitySuccess)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.postcodeTextField.endEditing(true)
    }

    func configureButton(button: UIButton) {
        button.backgroundColor = Colors.light
        button.setTitleColor(Colors.main, for: .normal)
        button.layer.cornerRadius = 15
    }

    // MARK: - Location

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude

        self.performSegue(withIdentifier: "showStreetLevelResults", sender: self)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ErrorDialog().showFor(view: self)
    }

    // MARK: - Button actions

    @objc func onUseMyLocationSelected() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }

    @objc func onSearchSelected() {
        guard let postcode = self.postcodeTextField.text else { return }
        Alamofire
            .request("https://api.postcodes.io/postcodes/\(postcode)")
            .responseJSON(completionHandler: onLocationSuccess)
    }

    @objc func onBrowseByLocationSelected() {
        self.performSegue(withIdentifier: "showLocation", sender: self)
    }

    // MARK: - Picker view data source
    // TODO: Figure out why this doesn't work in a separate file

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.availabilityResults.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.availabilityResults[row].date
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = self.availabilityResults[row].date

        return NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }

    // MARK: - Network

    func onAvailabilitySuccess(response: DataResponse<Any>) {
        guard let json = response.result.value else {
            return self.onError(error: "No JSON response received")
        }
        let arr = json as! [Dictionary<String, Any>]
        let results = arr.map { raw -> Availability in return Availability(data: raw) }

        DispatchQueue.main.async {
            self.availabilityResults = results
            self.datePickerView.reloadAllComponents()
        }
    }

    func onLocationSuccess(response: DataResponse<Any>) {
        guard let json = response.result.value else {
            return self.onError(error: "No JSON response received")
        }
        let dict = json as! Dictionary<String, Any>
        let result = Location(data: dict["result"] as! Dictionary<String, Any>)

        self.latitude = result.latitude
        self.longitude = result.longitude
        self.postcode = self.postcodeTextField.text?.uppercased()

        self.performSegue(withIdentifier: "showStreetLevelResults", sender: self)
    }

    func onError(error: String) {
        ErrorDialog().showFor(view: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showStreetLevelResults":
            let svc = segue.destination as! StreetLevelTableViewController
            let date = self.availabilityResults[self.datePickerView.selectedRow(inComponent: 0)].date

            svc.latitude = self.latitude
            svc.longitude = self.longitude
            svc.date = date
            if let postcode = self.postcode {
                svc.viewTitle = "\(postcode) - \(date)"
            } else {
                svc.viewTitle = date
            }
        default:
            return
        }
    }

}
