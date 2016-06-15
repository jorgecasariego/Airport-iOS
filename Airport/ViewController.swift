//
//  ViewController.swift
//  Airport
//
//  Created by Jorge Casariego on 12/6/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//
// Ejemplo tomado de aquí: http://developer.estimote.com/ibeacon/tutorial/part-3-ranging-beacons/
/*
    1. Starting ranging is very similar to starting monitoring—we also need to provide a beacon region that will define which beacons to scan for.
    2. Let’s say we’re interested in all the beacons installed at the airport. 
 
    OBS: A more idiomatic way would be to have the beacon manager we already have in the AppDelegate to manipulate a data model, and the View Controller observing the changes to the data model instead. We just want to keep thing simple in this tutorial.
 
    For this example we need:
    3. A data structure to hold the food options, beacons, and the distances between the two.
    4. we need to code up a simple algorithm:
 
        - Take the closest beacon.
        - Look up all the food places and the distances between them, and the beacon.
        - Sort the food places by the distance.
 */


import UIKit

// 1. Add the ESTBeaconManagerDelegate protocol
class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    // 2. Add the beacon manager and the beacon region
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "ranged region")
    
    // 5. 
    let placesByBeacons = [
        "64160:33963": [
            "Heavenly Sandwiches": 50,  // read as: it's 50 meters from
                                        // "Heavenly Sandwiches" to the beacon with
                                        // major 64160 and minor 33963
            "Green & Green Salads": 150,
            "Mini Panini": 325
        ],
        "18827:53794": [
            "Heavenly Sandwiches": 250,
                                        // read as: it's 50 meters from
                                        // "Heavenly Sandwiches" to the beacon with
                                        // major 18827 and minor 53794
            "Green & Green Salads": 100,
            "Mini Panini": 20
        ],
        "45082:34365": [
            "Heavenly Sandwiches": 350,
                                        // read as: it's 50 meters from
                                        // "Heavenly Sandwiches" to the beacon with
                                        // major 18827 and minor 53794
            "Green & Green Salads": 500,
            "Mini Panini": 170
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestAlwaysAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 5. Code to start ranging as the view controller appears on screen
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.beaconManager.stopMonitoringForRegion(self.beaconRegion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // We’ll implement a method that takes a CLBeacon object representing the closest beacon, and return a list of all the places sorted by their distance to the beacon
    func placesNearBeacon(beacon: CLBeacon) ->[String]? {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        
        if let places = self.placesByBeacons[beaconKey] {
            let sortedPlaces = Array(places).sort { $0.1 < $1.1 }.map { $0.0 }
            
            return sortedPlaces
        }
        
        return nil
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if let nearestBeacon = beacons.first, places = placesNearBeacon(nearestBeacon) {
            print("Lugares: \(places)")
        }
    }


}

