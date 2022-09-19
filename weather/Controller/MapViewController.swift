//
//  MapViewController.swift
//  weather
//
//  Created by Vlad Rakovich on 17.09.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentCoord: Coord = Coord(lat: 0, lon: 0)
    
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set map
        map.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        gestureRecognizer.delegate = self
        map.addGestureRecognizer(gestureRecognizer)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        //setting of location manager
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    //tap button to understand - where am I
    @IBAction func tapShowMe(_ sender: Any) {
        //go to main view
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainViewController
        //set of initial coordinate
        mainViewController.point = currentCoord
        self.present(mainViewController, animated:true, completion:nil)
    }
    
    
    //tap on map
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: map)
        let coordinate = map.convert(location, toCoordinateFrom: map)
        //go to main view
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainViewController
        //set of initial coordinate
        mainViewController.point = Coord(lat: coordinate.latitude, lon: coordinate.longitude)
        self.present(mainViewController, animated:true, completion:nil)

    }
    
    
    //get current coordinate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            print("Error coordinate")
            return
        }
        currentCoord = Coord(lat: locValue.latitude, lon: locValue.longitude)
    }

}
