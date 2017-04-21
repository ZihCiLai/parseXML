//
//  DetailViewController.swift
//  SwiftHelloRSSReader
//
//  Created by Lai Zih Ci on 2017/2/22.
//  Copyright © 2017年  Lai Zih-Ci. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var theWebView: UIWebView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.

        if self.detailItem == nil
        {
            return
        }
        
        
        let newsInfo = self.detailItem as! NewsItem
        
        self.title = newsInfo.title
        
        let url = URL(string: newsInfo.link!)
        
        let request = URLRequest(url: url!)
        
        theWebView?.loadRequest(request)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

