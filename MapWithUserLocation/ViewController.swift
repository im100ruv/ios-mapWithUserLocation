//
//  ViewController.swift
//  MapWithUserLocation
//
//  Created by Im100ruv on 24/02/18.
//  Copyright © 2018 Im100ruv. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var LongitudeLbl: UILabel!
    @IBOutlet weak var courseLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var altitudeLbl: UILabel!
    @IBOutlet weak var nearestAddressLbl: UILabel!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.02
        let longDelta: CLLocationDegrees = 0.02
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        // Displaying location details
        self.latitudeLbl.text = String(userLocation.coordinate.latitude)
        self.LongitudeLbl.text = String(userLocation.coordinate.longitude)
        self.courseLbl.text = String(userLocation.course)
        self.speedLbl.text = String(userLocation.speed)
        self.altitudeLbl.text = String(userLocation.altitude)
        
        // Getting user location details
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                if let placemark = placemarks?[0] {
                    
                    var address = ""
                    if placemark.subThoroughfare != nil {
                        address += placemark.subThoroughfare!
                    }

                    if placemark.thoroughfare != nil {
                        address += " " + placemark.thoroughfare!
                    }

                    if placemark.subLocality != nil {
                        address += "\n" + placemark.subLocality!
                    }
                    
                    if placemark.subAdministrativeArea != nil {
                        address += " " + placemark.subAdministrativeArea!
                    }

                    if placemark.postalCode != nil {
                        address += "\n" + placemark.postalCode!
                    }

                    if placemark.country != nil {
                        address += " " + placemark.country! + "\n"
                    }
                    
                    self.nearestAddressLbl.text = address

//                    print("\n" + subThoroughFare + " " + thoroughFare + "\n" + subLocality + " " + subAdministrativeArea + "\n" + postalCode + " " + country)
                }
            }
        }

    }


}

