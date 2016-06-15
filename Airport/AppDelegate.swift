//
//  AppDelegate.swift
//  Airport
//
//  Created by Jorge Casariego on 12/6/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//
//  Tutorial: http://developer.estimote.com/ibeacon/tutorial/part-1-setting-up/
/*
    1. You can think of beacon monitoring as a geofence
    2. Moving and out of the area it encloses triggers “enter” and “exit” events, which the app can react to.
    3. In case of iBeacon, the area is defined by the range of one or more beacons.
    4. Beacon geofences are also more responsive: “enter” events usually take up to a few seconds to trigger, “exit” events up to 30 seconds. 
    5.  iOS will keep listening for those beacons at all times—even if your app is not running or was terminated, and even if the iPhone/iPad is locked or rebooted.
    6. Once an “enter” or “exit” happens, iOS will launch the app into the background (if needed) and let it execute some code for a few seconds to handle the event.
    7. Beacon region is like a filter or a regular expression:
        each beacon is identified by three values:
        1. UUID
        2. major number
        3. minor number
       With beacon regions, you can say, “I’m only interested in beacons with UUID ‘ABC’ and major ‘XYZ’.”
    8. By default, iOS only gives your app a few seconds of execution time to handle the “enter” and “exit” events in the background. If you need more (e.g., to handle long-running API requests), start a background task.
 */

import UIKit

// 1. Add the ESTBeaconManagerDelegate protocol
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    
    // 2. Add a property to hold the beacon manager and instantiate it
    let beaconManager = ESTBeaconManager()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        
        // 4. location permission
        self.beaconManager.requestAlwaysAuthorization()
        
        // 5. Start monitoring
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            major: 64160, minor: 33963, identifier: "monitored region"))
        
        // 6. Permission to show notifications
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert, categories: nil))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        let notification = UILocalNotification()
        
        notification.alertBody =
            "Your gate closes in 47 minutes. " +
            "Current security wait time is 15 minutes, " +
            "and it's a 5 minute walk from security to the gate. " +
            "Looks like you've got plenty of time!"
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }


}

