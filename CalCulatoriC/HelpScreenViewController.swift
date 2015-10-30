//
//  HelpScreenViewController.swift
//  CalCulatoriC
//
//  Created by Hadi Sharghi on ۱۳۹۴/۸/۷ .
//  Copyright © ۱۳۹۴ ه‍.ش. Al00X. All rights reserved.
//

import UIKit

class HelpScreenViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var helpImageView: UIImageView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let image = UIImage(named: "helpImage.png")
//        
//        helpImageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func hide(sender: AnyObject) {
        
        
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
