//
//  MasterViewController.swift
//  iOS9_Contacts
//
//  Created by WataruSuzuki on 2015/08/14.
//  Copyright © 2015年 Wataru Suzuki. All rights reserved.
//

import UIKit
import Contacts

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var myContactStore = CNContactStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        switch status {
        case CNAuthorizationStatus.NotDetermined:
            myContactStore.requestAccessForEntityType(CNEntityType.Contacts) { (success, error) -> Void in
                if !success {
                    print(error?.description)
                }
            }
        default:
            break
        }

        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case SampleMenu.SHOW_ALL_LIST.segueId():
            //TODO
            break
        default:
            break
        }
    }

    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SampleMenu.MENU_MAX.rawValue
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = SampleMenu(rawValue: indexPath.row)?.toString()
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let segueId = SampleMenu(rawValue: indexPath.row)?.segueId()
        self.performSegueWithIdentifier(segueId!, sender: self)
    }

    enum SampleMenu : Int {
        case SHOW_ALL_LIST = 0,
        MENU_MAX
        
        func toString() -> String {
            switch self {
            case .SHOW_ALL_LIST: return "Show all contacts list"
            default: return ""
            }
        }
        
        func segueId() -> String {
            switch self {
            case .SHOW_ALL_LIST: return "ShowAllContactsList"
            default: return ""
            }
        }
    }
}

