//
//  InterfaceController.swift
//  MyNews Extension
//
//  Created by Lai Zih Ci on 2017/2/22.
//  Copyright © 2017年  Lai Zih-Ci. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var newsTable: WKInterfaceTable!

    var items = [NewsItem]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        guard let url = URL(string: "https://udn.com/rssfeed/news/1") else {
            print("Invalid URL.")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("Download RSS XML Fail:", error ?? "Download RSS XML Fail")
                return
            }
            // Parse and handle the XML
            guard let data = data else {
                print("Data is nil.")
                return
            }
            let content = String(data: data, encoding: .utf8)
            print("XML Content::", content ?? "nil")
            
            let parser = XMLParser(data: data)
            let parserDelegate = MyParserDelegate()
            parser.delegate = parserDelegate
            
            if parser.parse() {
                // Success
                print("Parse OK.")
                self.items = parserDelegate.resultArray
                // Show on UI.
                DispatchQueue.main.async {
                    self.newsTable.setNumberOfRows(self.items.count, withRowType: "NewsRowController")
                    // Assign the content of items in Table
                    for i in 0..<self.items.count {
                        guard let row = self.newsTable.rowController(at: i) as? NewsRowController else {
                            return
                        }
                        let item = self.items[i]
                        row.titleLabel.setText(item.title)
                        row.pubDateLabel.setText(item.pubDate)
                    }
                }
                
            } else {
                // Fail
                print("Parse Fail.")
            }
        }
        task.resume()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        //
        let item = items[rowIndex]
        return item
    }

}
