//
//  ViewController.swift
//  Where Was I
//
//  Created by Durgesh Ghuge on 24/07/2020.


import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        UpdateSavedPin()
    }
    
    func UpdateSavedPin () {
        if let oldCoords = DataStore().GetLastLocation() {
            
            let annoRem = mapView.annotations.filter{$0 !== mapView.userLocation}
            mapView.removeAnnotations(annoRem)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = Double(oldCoords.latitude)!
            annotation.coordinate.longitude = Double(oldCoords.longitude)!
            
            annotation.title = "I was here!"
            annotation.subtitle = "Remember?"
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func SaveButtonClicked(_ sender: AnyObject) {
        let coord = locationManager.location?.coordinate
        
        if let lat = coord?.latitude {
            if let long = coord?.longitude {
                DataStore().StoreDataPoint(latitude: String(lat), longitude: String(long))
                UpdateSavedPin()
            }
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            print("Location not enabled")
            return
        }
        
        print("Location allowed")
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

