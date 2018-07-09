//
//  AppDelegate.swift
//  todayExtension1
//
//  Created by IOSDEV on 2018. 7. 3..
//  Copyright © 2018년 IOSDEV. All rights reserved.
//

import UIKit
import CallKit
import MessageUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var timerCount = 0
    var mTimer : Timer?
    var resultString  = ""
    
    var bDeviceLocked = false
    var callObserver: CXCallObserver!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("applicationWillResignActive")
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceOpenCallback(notification:)), name: Notification.Name("Noti_DeviceOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceLockCallback(notification:)), name: Notification.Name("Noti_DeviceLock"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.smsActionCallback(notification:)), name: NSNotification.Name.MFMessageComposeViewControllerTextMessageAvailabilityDidChange, object: nil)
        registerforDeviceLockNotification()
        // Override point for customization after application launch.
        return true
    }
    @objc func deviceOpenCallback(notification: Notification){
        print("Noti_DeviceOpen 열림")
    }
    @objc func deviceLockCallback(notification: Notification){
        print("Noti_DeviceLock 잠김")
    }
    
    @objc func smsActionCallback(notification: Notification){
        print("콜백 ========== smsActionCallback")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        var allUsageInfo :DataUsageInfo?
        
        allUsageInfo = SystemDataUsage.getDataUsage();
        // Do any additional setup after loading the view, typically from a nib.
        var resultStr = allUsageInfo?.wifiReceived
        print("와이파이 사용량    \(resultStr)")
        var resultStr2 = allUsageInfo?.wirelessWanDataReceived
        print("무선 사용량     \(resultStr)")
       // DispatchQueue.main.async {
            //  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallback2), userInfo: nil, repeats: true)
       // }
 
                 //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallback), userInfo: nil, repeats: true)

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    //    print("applicationDidEnterBackground")
        UIApplication.shared.beginBackgroundTask(withName: "back1", expirationHandler: nil)
        timerCount = 0;
        mTimer =   Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCallback2), userInfo: nil, repeats: true)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.callbackFunc),
//                                               name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        resultString  = "======      UIApplicationDidEnterBackgroundNotification"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.callbackFunc),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
     //   print("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
      //  print("applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationProtectedDataDidBecomeUnAvailable(_ application: UIApplication) {
        print("applicationProtectedDataDidBecomeUnAvailable")
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        print("applicationProtectedDataDidBecomeAvailable")
    }
    
    @objc func callbackFunc(){
      //  print("callbackFunc \(self.resultString)")
    }
    
//     func displayStatusChanged( center :CFNotificationCenter,  observer: Void, name :CFString ,object: Void, userInfo :CFDictionary )
//    {
//         print("displayStatusChanged 화면잠금?????")
//    }
    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
      //  print("============DEVICE LOCKED\(cfName?.rawValue as? String)")
        let lockState = cfName?.rawValue as! String
        
        
        if (lockState == "com.apple.springboard.hasBlankedScreen") {
           // print("DEVICE OPEN")
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Notification.Name("Noti_DeviceOpen"), object: nil)
              //  print("쓰레드 DEVICE OPEN")
            })
          
        }
        else if (lockState == "com.apple.springboard.lockcomplete") {
           // print("DEVICE LOCKED")
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Notification.Name("Noti_DeviceLock"), object: nil)
             //   print("쓰레드 DEVICE LOCK")
            })
          
        } else if(lockState == "com.apple.springboard.lockstate") {
          
        }
        //어쩃든 이게 호출되면 잠김 (1초안에
        //print("============DEVICE LOCKED \(lockState)")
        //let catcher = Unmanaged<MyClassObserving>.fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!)).takeUnretainedValue()
       // catcher.displayStatusChanged(lockState)
    }
    
//    private func displayStatusChanged(_ lockState: String) {
//        // the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
//
//    }
    private let displayStatusOpenCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        //  print("============DEVICE LOCKED\(cfName?.rawValue as? String)")
       // let lockState = cfName?.rawValue as! String
        
     
            print("DEVICE OPEN")
        
//        CFNotificationCenterRemoveObserver(CFNotificationCenterGetLocalCenter(),
//                                           Unmanaged.passUnretained(self).toOpaque(),
//                                           nil,
//                                           nil)
        //print("============DEVICE LOCKED \(lockState)")
        //let catcher = Unmanaged<MyClassObserving>.fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!)).takeUnretainedValue()
        // catcher.displayStatusChanged(lockState)
    }
    private let displayStatusHasBlankCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        //  print("============DEVICE LOCKED\(cfName?.rawValue as? String)")
        // let lockState = cfName?.rawValue as! String
        
        
        print("DEVICE OPEN")
        
        //        CFNotificationCenterRemoveObserver(CFNotificationCenterGetLocalCenter(),
        //                                           Unmanaged.passUnretained(self).toOpaque(),
        //                                           nil,
        //                                           nil)
        //print("============DEVICE LOCKED \(lockState)")
        //let catcher = Unmanaged<MyClassObserving>.fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!)).takeUnretainedValue()
        // catcher.displayStatusChanged(lockState)
    }
    func registerforDeviceLockNotification() {
        
        //CFNotificationCenterAddObserver(center)
        //Screen lock notifications
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),     //center
            Unmanaged.passUnretained(self).toOpaque(),     // observer
            displayStatusChangedCallback,     // callback
            "com.apple.springboard.hasBlankedScreen" as CFString,     // event name
            nil,     // object
            .deliverImmediately) //잠길떄만 호출
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),     //center
            Unmanaged.passUnretained(self).toOpaque(),     // observer
            displayStatusChangedCallback,     // callback
            "com.apple.springboard.lockcomplete" as CFString,     // event name
            nil,     // object
            .deliverImmediately) //잠길떄만 호출
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),     //center
            Unmanaged.passUnretained(self).toOpaque(),     // observer
            displayStatusChangedCallback,     // callback
            "com.apple.springboard.lockstate" as CFString,    // event name
            nil,     // object
            .deliverImmediately)
    }
    

    @objc func timerCallback2(){
        
      //  registerforDeviceLockNotification()
        
        
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =  UIApplication.sharedApplication().applicationState
     //   print("UIApplication.shared.isProtectedDataAvailable \(UIApplication.shared.isProtectedDataAvailable)")
       // NotificationCenter.default.post(name:NSNotification.Name(rawValue: "PostButton"),object:nil)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.callbackFunc),
//                                               name: NSNotification.Name.UIApplicationProtectedDataWillBecomeUnavailable, object: nil)
        
        timerCount += 1
        
        if(timerCount > 2000){
            print("앱 20회");
            self.mTimer?.invalidate()
            return
        }
        if state == .background {
           // print("앱 background");
            // break;
            // background
        }
        else if state == .active {
            
         //   print("앱 active");
            // foreground
        }else if state == UIApplicationState.inactive {
         //   print("앱 inactive");
            // foreground
        }
    }


}

extension AppDelegate: CXCallObserverDelegate ,MFMessageComposeViewControllerDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            print("Disconnected")
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("Dialing")
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("Incoming")
        }
        
        if call.hasConnected == true && call.hasEnded == false {
            print("Connected")
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        print("messageComposeViewController")
    }
}

