//
//  SelectUnitView.swift
//  CalCulatoriC
//
//  Created by Reza Sheikhizadeh on ۹۴/۴/۲۴.
//  Copyright (c) ۱۳۹۴ ه‍.ش. Al00X. All rights reserved.
//

import UIKit

protocol UnitSelectionDelegate:class {
    func unitSelectionChanged(newUnit:String)
}

class SelectUnitView: UITableViewController {

    var dict: NSDictionary!
    var defaultUser = NSUserDefaults.standardUserDefaults()
    var firstUnitSelected : Bool = false
    var parentVC = SelectConverterView()
    weak var delegate:UnitSelectionDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var selectedConvert: String = (defaultUser.valueForKey("selectedConvert") as! String)
        
        var path = NSBundle .mainBundle().pathForResource(selectedConvert, ofType: "plist")
        dict = NSDictionary(contentsOfFile: path!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dict.count+1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // <-------------------------------------------------->
        // **COLOR SET**
        // Start
        
        var themeN: Int! = defaultUser.integerForKey("themeNumber")
        var theme: String! = defaultUser.stringForKey("Theme")
        var path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
        var dic = NSDictionary(contentsOfFile: path!)
        var hexColor = dic?.valueForKey("theme" + (themeN! as NSNumber).stringValue) as? String
        var lable = cell.viewWithTag(100) as? UILabel
        
        if (theme == "Black")
        {
            cell.backgroundColor = UIColor.blackColor()
            lable?.textColor = UIColor.whiteColor()
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
            lable?.textColor = UIColor.blackColor()
        }
        
        // END
        
        // <-------------------------------------------------->
        // **UNIT NAMES SET**
        // START
        
        var row: Int = dict.count
        
        if (indexPath.row == row)
        {
            lable?.text = "< Back"
            
        }
        else
        {
            var unitList: AnyObject? = dict.allKeys[indexPath.row]
            lable?.text = (unitList as! String)
        }
        
        // END
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var row: Int = dict.count
        var selectedIndexPath = self.tableView.indexPathForSelectedRow?.row
        if (row != selectedIndexPath)
        {
            var unitList: AnyObject? = dict.allKeys[selectedIndexPath!]
                
//            parentVC.selectedFromUnitView = (unitList as String)
            self.delegate?.unitSelectionChanged(unitList as! String)

        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
}
