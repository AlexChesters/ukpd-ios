//
//  MapViewController.swift
//  ukpd
//
//  Created by Alex Chesters on 01/09/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    public var crime: StreetLevelCrime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self

        let centerCoordinate = CLLocationCoordinate2D(latitude: self.crime.latitude, longitude: self.crime.longitude)

        self.mapView.centerCoordinate = centerCoordinate

        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate

        self.mapView.addAnnotation(annotation)

        let region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 5000, 5000)

        self.mapView.setRegion(region, animated: true)

        let recogniser = UIGestureRecognizer(target: self, action: #selector(onMapTap))
        recogniser.delegate = self
        self.mapView.addGestureRecognizer(recogniser)
    }

    @objc func onMapTap(recogniser: UIGestureRecognizer) {
        print("gesture")
        let point = recogniser.location(in: self.mapView)
        let tapPoint = self.mapView.convert(point, toCoordinateFrom: self.mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = tapPoint

        self.mapView.addAnnotation(annotation)

        let region = MKCoordinateRegionMakeWithDistance(tapPoint, 5000, 5000)

        self.mapView.setRegion(region, animated: true)
    }

}
