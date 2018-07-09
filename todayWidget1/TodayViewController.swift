//
//  TodayViewController.swift
//  todayWidget1
//
//  Created by IOSDEV on 2018. 7. 3..
//  Copyright © 2018년 IOSDEV. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var widgetText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let ud =  UserDefaults.init(suiteName: "group.hgreat.test.widget")?.value(forKey: "thisText") {
            self.widgetText.text = ud as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
//        if let ud =  UserDefaults.init(suiteName: "group.hgreat.test.widget")?.value(forKey: "thisText"){
//            self.widgetText.text = ud as? String
//
//        }else{
//            self.widgetText.text = "This is Empty"
//        }
       // let contactDB = FMDatabase(path: "")
        completionHandler(NCUpdateResult.newData)
    }
    
   
    
}
