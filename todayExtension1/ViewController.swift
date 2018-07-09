//
//  ViewController.swift
//  todayExtension1
//
//  Created by IOSDEV on 2018. 7. 3..
//  Copyright © 2018년 IOSDEV. All rights reserved.
//

import UIKit
import NetworkExtension
import Foundation
import KeychainSwift



class ViewController: UIViewController {

    @IBOutlet weak var inputBox1: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var databasePath = String()
    
    var mTimer : Timer?
    
    @IBAction func saveBtnClicked(_ sender: Any) {
       
    }
    
    @IBAction func findBtnClicked(_ sender: Any) {
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectVPN {
            
        }
//        var allUsageInfo :DataUsageInfo?
//
//        allUsageInfo = SystemDataUsage.getDataUsage();
//        // Do any additional setup after loading the view, typically from a nib.
//        var resultStr = allUsageInfo?.wifiReceived
//        print("와이파이 사용량"+resultStr)
//        var resultStr2 = allUsageInfo?.wirelessWanDataReceived
//         print("무선 사용량"+resultStr2)
        
        
    }
    @objc func timerCallback(){
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =  UIApplication.sharedApplication().applicationState
        print("UIApplication.shared.isProtectedDataAvailable \(UIApplication.shared.isProtectedDataAvailable)")
        if state == .background {
            print("앱 background");
            // break;
            // background
        }
        else if state == .active {
            UIApplication.shared.isProtectedDataAvailable
            print("앱 active");
            // foreground
        }else if state == UIApplicationState.inactive {
            print("앱 inactive");
            // foreground
        }
    }
    
  
    @IBAction func btnConfirm(_ sender: Any) {
       //let defaults =  UserDefaults(suiteName: "group.hgreat.test.widget")
        //defaults?.set(self.inputBox1.text, forKey: "thisText")
        
        UserDefaults.init(suiteName: "group.hgreat.test.widget")?.set(self.inputBox1.text,forKey: "thisText")
        UserDefaults.init(suiteName: "group.hgreat.test.widget")?.synchronize()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func connectVPN(completion: @escaping () -> Void) {
        let keychain = KeychainSwift()
        keychain.set("<mypassword>", forKey: "passref")
        keychain.set("<sharedsecretpassword>", forKey: "secretref")
        
        NEVPNManager.shared().loadFromPreferences { error in
            let vpnhost = "125.209.222.142"
            let username = "<myusername>"
            
            let p = NEVPNProtocolIPSec()
            p.username = username
            p.localIdentifier = username
            p.serverAddress = vpnhost
            p.remoteIdentifier = vpnhost
            p.authenticationMethod = .sharedSecret
            p.disconnectOnSleep = false
            
            p.sharedSecretReference = keychain.getData("secretref")
            p.passwordReference = keychain.getData("passref")
            
            var rules = [NEOnDemandRule]()
            let rule = NEOnDemandRuleConnect()
            rule.interfaceTypeMatch = .any
            rules.append(rule)
            
            NEVPNManager.shared().localizedDescription = "My VPN"
            NEVPNManager.shared().protocolConfiguration = p
            NEVPNManager.shared().onDemandRules = rules
            NEVPNManager.shared().isOnDemandEnabled = true
            NEVPNManager.shared().isEnabled = true
            NEVPNManager.shared().saveToPreferences { error in
                if (error != nil) {
                    print(error!)
                } else {
                    do {
                        try NEVPNManager.shared().connection.startVPNTunnel()
                        completion()
                    } catch {
                        print("can't connect VPN'")
                    }
                }
            }
        }
    }


}

