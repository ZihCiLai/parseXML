//
//  MyParserDelegate
//  SwiftHelloRSSReader
//
//  Created by Lai Zih Ci on 2017/2/22.
//  Copyright © 2017年  Lai Zih-Ci. All rights reserved.
//

import Foundation

class MyParserDelegate:NSObject,XMLParserDelegate {
    
    var currentNewsItem:NewsItem?
    
    var currentElementValue:String?
    
    var resultArray = [NewsItem]()
    
    override init()
    {
        super.init()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "title" || elementName == "link" || elementName == "pubDate" || elementName == "description"
        {
            currentElementValue = nil
        }
        else if elementName == "item"
        {
            currentNewsItem = NewsItem()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElementValue == nil
        {
            currentElementValue = string
        }
        else
        {
            currentElementValue = currentElementValue! + string
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "title"
        {
            currentNewsItem?.title = currentElementValue
        }
        else if elementName == "link"
        {
            currentNewsItem?.link = currentElementValue
        }
        else if elementName == "pubDate"
        {
            currentNewsItem?.pubDate = currentElementValue
        }
        else if elementName == "description"
        {
            currentNewsItem?.description = currentElementValue
        }
        else if elementName == "item"
        {
            resultArray.append(currentNewsItem!)
            currentNewsItem = nil
        }

    }
}
