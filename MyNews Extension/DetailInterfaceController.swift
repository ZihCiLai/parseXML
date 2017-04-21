//
//  DetailInterfaceController.swift
//  SwiftHelloRSSReader
//
//  Created by Lai Zih Ci on 2017/2/22.
//  Copyright © 2017年  Lai Zih-Ci. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    @IBOutlet var descriptionLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        guard let item = context as? NewsItem else {
            print("Invalid context.")
            return
        }
        
        // Assign title
        self.setTitle(item.title)
        
        // Assign Description
        guard let text = item.description else {
            return
        }
        descriptionLabel.setText(stripHTMLTag(input: text))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func stripHTMLTag(input: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: "<.*?>", options: [. caseInsensitive])  else {
            print("Fail to create regex.")
            return input
        }
        let range = NSMakeRange(0, input.characters.count)
        let output = regex.stringByReplacingMatches(in: input, options:[], range: range, withTemplate: "<.!.>")
        return output
    }
}
