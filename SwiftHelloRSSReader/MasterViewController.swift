//
//  MasterViewController.swift
//  SwiftHelloRSSReader
//
//  Created by Lai Zih Ci on 2017/2/22.
//  Copyright © 2017年  Lai Zih-Ci. All rights reserved.
//
import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = NSMutableArray()
    
    var yahooReach:Reachability?

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            let navigatorController = controllers[controllers.count-1] as! UINavigationController
            self.detailViewController = navigatorController.topViewController as? DetailViewController
        }
        
        // Prepare Refresh Button
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(MasterViewController.downloadList))
        self.navigationItem.rightBarButtonItem = refreshButton
        
        // Start Reachability
        NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.networkStatusChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        yahooReach = Reachability(hostName: "tw.news.yahoo.com")
        yahooReach?.startNotifier()
    }
    
    func networkStatusChanged(_ notify: Notification)
    {
        let status = yahooReach?.currentReachabilityStatus().rawValue
        
        print("NetworkStatus Changed:", status ?? "nil")
        
        if status == NotReachable.rawValue
        {
            //...
        }
        else
        {
            downloadList()
        }
        
    }
    
    func checkInternet() -> Bool {
        
        if yahooReach?.currentReachabilityStatus().rawValue == NotReachable.rawValue
        {
            let alertView = UIAlertView(title: nil, message: "Can't access Internet. \nPlease check your network status.", delegate: nil, cancelButtonTitle: "OK")
            
            alertView.show()
            
            return false
        }
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
        
        yahooReach?.stopNotifier()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: AnyObject) {
        objects.insert(Date(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[(indexPath as NSIndexPath).row] as! NewsItem
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return checkInternet()
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 

        let object = objects[(indexPath as NSIndexPath).row] as! NewsItem
        cell.textLabel!.text = object.title
        cell.detailTextLabel!.text = object.pubDate
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.removeObject(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
// MARK: Download and Parse
    
    func downloadList() {
        
        if checkInternet() == false
        {
            return
        }
        
        
        let url = URL(string: "https://udn.com/rssfeed/news/1")
        
        // Save to NSUserDefault
        
        let defaults = UserDefaults(suiteName: "group.newsApp")
        defaults!.set(url, forKey: "NewsURL")
        defaults!.synchronize()
        
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 120)
    
        let queue = OperationQueue.current
    
        NSURLConnection.sendAsynchronousRequest(request, queue: queue!) { (response, xmlData, error) -> Void in
            
            if let data = xmlData {
                let parser = XMLParser(data: data)
                let parserDelegate = MyParserDelegate()
                
                parser.delegate = parserDelegate
                
                let success = parser.parse()
                
                if success {
                    self.objects.removeAllObjects()
                    self.objects.addObjects(from: parserDelegate.resultArray)
                    self.tableView.reloadData()
                }
            }
        }
    }
}







