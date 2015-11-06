//
//  help1View.swift
//  CalCulatoriC
//
//  Created by Reza Sheikhizadeh on ۹۴/۶/۲۲.
//  Copyright (c) ۱۳۹۴ ه‍.ش. Al00X. All rights reserved.
//

import UIKit

class help1View: UIViewController {

    
    @IBOutlet var _VIEW: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        _VIEW.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapGesture(sender: UITapGestureRecognizer)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
