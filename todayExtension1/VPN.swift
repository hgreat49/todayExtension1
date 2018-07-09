//
//  VPN.swift
//  todayExtension1
//
//  Created by IOSDEV on 2018. 7. 6..
//  Copyright © 2018년 IOSDEV. All rights reserved.
//

import Foundation
import NetworkExtension
import Security


class VPN{
    let vpnManager = NEVPNManager.shared();
    var vpnlock = false
    
    private var vpnLoadHandler: (Error?) -> Void { return
    { (error:Error?) in
        if ((error) != nil) {
            print("Could not load VPN Configurations")
            return;
        }
        let p = NEVPNProtocolIPSec()
        p.username = "SOME_USERNAME"
        p.serverAddress = "example.com"
        p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
        
      //  let kcs =  KeychainService();
      //  kcs.save(key: "SHARED", value: "MY_SHARED_KEY")
      //  kcs.save(key: "VPN_PASSWORD", value: "MY_PASSWORD"
            p.sharedSecretReference = nil //kcs.load(key: "SHARED")
            p.passwordReference = nil // kcs.load(key: "VPN_PASSWORD)
            p.useExtendedAuthentication = true
            p.disconnectOnSleep = false
            self.vpnManager.protocolConfiguration = p
            self.vpnManager.localizedDescription = "Contensi"
            self.vpnManager.isEnabled = true
            self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
            } }
            
            private var vpnSaveHandler: (Error?) -> Void { return
        { (error:Error?) in
            if (error != nil) {
            print("Could not save VPN Configurations")
            return
            } else {
            do {
            try self.vpnManager.connection.startVPNTunnel()
            } catch let error {
            print("Error starting VPN Connection \(error.localizedDescription)");
            }
            }
            }
            self.vpnlock = false
                self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
            }
    
    
}

           // public func connectVPN() {
            //For no known reason the process of saving/loading the VPN configurations fails.On the 2nd time it works
            
            
          //  public func disconnectVPN() ->Void {
           // vpnManager.connection.stopVPNTunnel()
         //  / }

