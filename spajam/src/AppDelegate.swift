//
//  AppDelegate.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/02.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager : CLLocationManager? = nil
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        let mn = CLLocationManager()
        self.locationManager = mn
        mn.delegate = self
        mn.requestAlwaysAuthorization()
        mn.startUpdatingLocation()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    
    //Location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    }
}

