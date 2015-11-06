//
//  ViewController.swift
//  SwiftTest
//
//  Created by Reza Sheikhizadeh on ۹۴/۴/۱۶.
//  Copyright (c) ۱۳۹۴ ه‍.ش. Al00X. All rights reserved.
//

import UIKit
import MessageUI

class View6: UIViewController,  MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet var convertButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var cclearButton: UIView!
    @IBOutlet var _view: UIView!
    @IBOutlet var previewSymbol: UILabel!
    @IBOutlet var previewLable: UILabel!
    @IBOutlet var lable1: UILabel!
    @IBOutlet var DisButton: UIButton!
    @IBOutlet var timeButton: UIButton!
    @IBOutlet var themeButton: UIButton!
    
    var firstNumber: String! = ""
    var secondNumber: String! = ""
    var dot:Bool = false
    var negative:Bool = false
    var themeNum: Int! = 0
    var defaultUser = NSUserDefaults.standardUserDefaults()
    internal var convertHoldedNum: String!
    
    @IBOutlet var lableMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (defaultUser.valueForKey("holdedNumber") == nil)
        {
            defaultUser.setObject("0", forKey: "holdedNumber")
        }
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let holdD = UILongPressGestureRecognizer(target: self, action: "handleHoldsD:")
        let holdT = UILongPressGestureRecognizer(target: self, action: "handleHoldsT:")
        let holdTheme = UILongPressGestureRecognizer(target: self, action: "handleTheme:")
        
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        
        lable1.addGestureRecognizer(leftSwipe)
        lable1.addGestureRecognizer(rightSwipe)
        DisButton.addGestureRecognizer(holdD)
        timeButton.addGestureRecognizer(holdT)
        themeButton.addGestureRecognizer(holdTheme)
        
        lable1.text = "0"
        previewLable.text = "0"
        previewSymbol.text = ""
        
        lable1.text = (defaultUser.valueForKey("holdedNumber") as! String)
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        
        let themeN: Int! = defaultUser.integerForKey("themeNumber")
        let theme: String! = defaultUser.stringForKey("Theme")
        
        let path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        
        if (themeN != nil && themeN <= dic?.count)
        {
            themeNum = themeN
            
            let path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
            let dic = NSDictionary(contentsOfFile: path!)
            
            let hexColor = dic?.valueForKey("theme" + (themeNum! as NSNumber).stringValue) as? String
            
            for (var i = 1; i < 7; i++)
            {
                let btn = self.view.viewWithTag(i) as? UIButton
                
                btn?.backgroundColor = UIColor(rgba: "#" + hexColor!)
            }
        }
        if (theme != nil)
        {
            let pathW = NSBundle.mainBundle().pathForResource("Convert2Calculator_White", ofType: "png")
            let pathB = NSBundle.mainBundle().pathForResource("Convert2Calculator_Black", ofType: "png")
            let imgW: UIImage! = UIImage(contentsOfFile: pathW!)
            let imgB: UIImage! = UIImage(contentsOfFile: pathB!)
            
            if (theme == "Black")
            {
                self.view.backgroundColor = UIColor.blackColor()
                convertButton.setImage(imgB, forState: .Normal)
                for(var i = 10; i < 14; i++)
                {
                    let label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.whiteColor()
                    label?.backgroundColor = UIColor.blackColor()
                }
                for(var i = 14; i < 17; i++)
                {
                    let btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.blackColor()
                }
            }
            else
            {
                self.view.backgroundColor = UIColor.whiteColor()
                convertButton.setImage(imgW, forState: .Normal)
                for(var i = 10; i < 14; i++)
                {
                    let label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.blackColor()
                    label?.backgroundColor = UIColor.whiteColor()
                }
                
                for(var i = 14; i < 17; i++)
                {
                    let btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.whiteColor()
                }
            }
        }
        
        if (lable1.text == "0" || lable1.text == "-0")
        {
            clearButton.setTitle("AC", forState: .Normal)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberTouch(sender: UIButton) {
        
        let button = sender
        let num: String! = button.titleLabel?.text
        
        
        
        if ((lable1.text?.characters.count) < 15)
        {
            if (lable1.text == "0" || lable1.text == "")
            {
                lable1.text = num
            }
            else if (lable1.text == "-0")
            {
                lable1.text = "-" + num
            }
            else
            {
                lable1.text = lable1.text! + num
            }
            clearButton.setTitle("C", forState: .Normal)
        }
        else
        {
            lableMessage.text = "Maximum Length"
            
            if (lableMessage.text == "Maximum Length")
            {
                fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            }
        }
        
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
        
    }
    @IBAction func operatorTouch(sender: UIButton) {
        
        
        let button = sender
        _ = button.titleLabel?.text
        
        
        
        if (firstNumber == "")
        {
            previewSymbol.text = button.titleLabel?.text
            previewLable.text = lable1.text
            
            firstNumber = lable1.text
            lable1.text = "0"
        }
        else
        {
            previewSymbol.text = button.titleLabel?.text
            
            
            calculator()
        }
        
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
        clearButton.setTitle("C", forState: .Normal)
        
    }
    
    func fadeAnimationLable(i: NSTimeInterval, d: NSTimeInterval, fadeOut: Bool, lable: UILabel)
    {
        var fade: CGFloat
        
        if (fadeOut == true)
        {
            fade = 0.0
        }
        else
        {
            fade = 1.0
        }
        UIView.animateWithDuration(i, delay: d, options: UIViewAnimationOptions.CurveEaseOut, animations:{
            
            lable.alpha = fade
            
            }, completion: nil)
    }
    
    func calculator()
    {
        let first = previewLable.text
        let second = lable1.text
        
        let number1: Double = (first! as NSString).doubleValue
        let number2: Double = (second! as NSString).doubleValue
        var result: Double!
        let symbol = previewSymbol.text
        previewLable.text = lable1.text
        if (symbol == "+")
        {
            result = number1 + number2
        }
        else if (symbol == "-")
        {
            result = number1 - number2
        }
        else if (symbol == "×")
        {
            result = number1 * number2
        }
        else if (symbol == "÷")
        {
            if (number1 != 0)
            {
                result = number1 / number2
            }
            else
            {
                lableMessage.text = "Error"
                if (lableMessage.text == "Error")
                {
                    fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                    fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
                }
            }
        }
        if (result == nil)
        {
            result = 0
        }
        previewLable.text = lable1.text
        lable1.text = (result as NSNumber).stringValue
        firstNumber = ""
        
    }
    
    @IBAction func resultTouch(sender: UIButton) {
        
        
        calculator()
        
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
        clearButton.setTitle("C", forState: .Normal)
    }
    
    func update()
    {
        if (lable1.text == "inf")
        {
            lableMessage.text = "Infinity"
            if (lableMessage.text == "Infinity")
            {
                fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            }
            
            previewLable.text = "0"
            lable1.text = "0"
        }
        if (lable1.text == "Error" || lable1.text == "error" || lable1.text == "nan")
        {
            lableMessage.text = "Error"
            if (lableMessage == "Error")
            {
                fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            }
            
            previewLable.text = "0"
            lable1.text = "0"
            
            defaultUser.setObject(lable1.text, forKey: "holdedNumber")
        }
    }
    
    @IBAction func clearTouch(sender: UIButton)
    {
        if (lable1.text != "0")
        {
            lable1.text = "0"
            
        }else {
            lable1.text = "0"
            previewLable.text = "0"
            previewSymbol.text = ""
            firstNumber = ""
            secondNumber = ""
            negative = false
            dot = false
            clearButton.setTitle("AC", forState: .Normal)
        }
        if (previewLable.text == "0")
        {
            clearButton.setTitle("AC", forState: .Normal)
        }
        
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
    }
    @IBAction func negativeTouch(sender: UIButton)
    {
        if (negative == false)
        {
            negative = true
            
            lable1.text = "-" + lable1.text!
        }
        else
        {
            lable1.text = lable1.text?.stringByReplacingOccurrencesOfString("-", withString: "")
            negative = false
        }
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
        if (lable1.text == "-0" || lable1.text == "0")
        {
            clearButton.setTitle("AC", forState: .Normal)
        }
    }
    @IBAction func persentTouch(sender: UIButton)
    {
        var num = (lable1.text! as NSString).doubleValue
        num = num / 100
        lable1.text = (num as NSNumber).stringValue
        
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
        clearButton.setTitle("C", forState: .Normal)
    }
    @IBAction func dotTouch(sender: UIButton)
    {
        if (lable1.text!.rangeOfString(".") == nil)
        {
            if (lable1.text?.characters.count) < 14
            {
                lable1.text = lable1.text! + "."
                clearButton.setTitle("C", forState: .Normal)
            }
            else
            {
                lableMessage.text = "Maximum Length"
                if (lableMessage == "Maximum Length")
                {
                    fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                    fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
                }
                return
            }
            
        }
        else
        {
            lableMessage.text = "'.' Already Exist"
            if (lableMessage == "'.' Already Exist")
            {
                fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            }
        }
        
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
    }
    
    @IBAction func creditTouch(sender: UIButton)
    {
        let mail = MFMailComposeViewController()
        
        let OSversion = UIDevice.currentDevice().systemVersion
        let OSdevice = UIDevice.currentDevice().model
        var messageBody = "____________\nOS Version: "
        messageBody += OSversion
        messageBody += "\n"
        messageBody += "OS Model: "
        messageBody += OSdevice
        messageBody += "\n\n\n"
        messageBody += "- WRITE YOUR MESSAGE HERE -"
        
        mail.setSubject("CalCulatoriC")
        mail.setToRecipients(["aloox@gmail.com"])
        mail.setMessageBody(messageBody, isHTML: false)
        mail.mailComposeDelegate = self
        
        self.presentViewController(mail, animated: true, completion: nil)
        
        
        
        /*
        let alert = UIAlertController(title: "Credit", message:
            "Creator: Al00X - Ali Sheikhizadeh , Do you want to contact creator ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        self.presentViewController(alert, animated: false, completion: nil)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,
            handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler:
            {action in      
                
                let email = "aloo5416@gmail.com"
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
        
        }))
        
//        lableMessage.text = "Al00X - AliSheikhizadeh"
//        if (lableMessage.text == "Al00X - AliSheikhizadeh")
//        {
//            fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
//            fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
//        }
        */
        
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer)
    {
        if (lable1.text == "0" || lable1.text == "" || lable1.text == "-0")
        {
            lableMessage.text = "Cannot Delete"
            if (lableMessage.text == "Cannot Delete")
            {
                fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            }
        }
        else
        {
            if (lable1.text?.characters.count) < 2
            {
                lable1.text = "0"
            }
            else
            {
                lable1.text = String(lable1.text!.characters.dropLast())
            }
            
        }
    }
    
    func handleHoldsT(sender:UILongPressGestureRecognizer)
    {
        if (sender.state == UIGestureRecognizerState.Began)
        {
            var num:Double = (lable1.text! as NSString).doubleValue
            
            previewSymbol.text = "x²"
            previewLable.text = lable1.text
            
            num = pow(num, 2)
            
            lable1.text = (num as NSNumber).stringValue
        }
        
        if (lable1.text == "nan")
        {
            lable1.text = "0"
        }
    }
    func handleHoldsD(sender:UILongPressGestureRecognizer)
    {
        if (sender.state == UIGestureRecognizerState.Began)
        {
            var num:Double = (lable1.text! as NSString).doubleValue
            
            previewSymbol.text = "√"
            previewLable.text = lable1.text
            
            num = sqrt(num)
            
            lable1.text = (num as NSNumber).stringValue
        }
        if (lable1.text == "nan")
        {
            lable1.text = "0"
        }
    }
    @IBAction func themesTouch(sender: UIButton)
    {
        lableMessage.text = "Theme Changed"
        
        if (lableMessage.text == "Theme Changed")
        {
            fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
            fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
        }
        
        themeNum!++
        
        let path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        
        if (themeNum >= dic?.count)
        {
            themeNum = 0
        }
        NSLog((themeNum! as NSNumber).stringValue)
        let hexColor = dic?.valueForKey("theme" + (themeNum! as NSNumber).stringValue) as? String
        
        for (var i = 1; i < 7; i++)
        {
            let btn = self.view.viewWithTag(i) as? UIButton
            
            btn?.backgroundColor = UIColor(rgba: "#" + hexColor!)
        }
        
        defaultUser.setInteger(themeNum, forKey: "themeNumber")
    }
    
    func handleTheme(sender: UILongPressGestureRecognizer)
    {
        _ = UIColor(rgba: "#FFFFFF")
        _ = UIColor(rgba: "#000000")
        let pathW = NSBundle.mainBundle().pathForResource("Convert2Calculator_White", ofType: "png")
        let pathB = NSBundle.mainBundle().pathForResource("Convert2Calculator_Black", ofType: "png")
        let imgW: UIImage! = UIImage(contentsOfFile: pathW!)
        let imgB: UIImage! = UIImage(contentsOfFile: pathB!)
        if (sender.state == UIGestureRecognizerState.Began)
        {
            if (self.view.backgroundColor == UIColor.whiteColor())
            {
                self.view.backgroundColor = UIColor.blackColor()
                convertButton.setImage(imgB, forState: .Normal)
                for(var i = 10; i < 14; i++)
                {
                    let label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.whiteColor()
                    label?.backgroundColor = UIColor.blackColor()
                }
                for(var i = 14; i < 17; i++)
                {
                    let btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.blackColor()
                    
                    defaultUser.setObject("Black", forKey: "Theme")
                }
            }
            else
            {
                self.view.backgroundColor = UIColor.whiteColor()
                convertButton.setImage(imgW, forState: .Normal)
                for(var i = 10; i < 14; i++)
                {
                    let label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.blackColor()
                    label?.backgroundColor = UIColor.whiteColor()
                }
                
                for(var i = 14; i < 17; i++)
                {
                    let btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.whiteColor()
                    
                    defaultUser.setObject("White", forKey: "Theme")
                }
            }
        }
    }
    
    
    @IBAction func helpTouch(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("HelpScreenViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
//
//        let vc = HelpScreenViewController()
//        self.presentViewController(vc, animated: true, completion: nil)
        

        
    }
    
    @IBAction func toConvertTouch(sender: UIButton)
    {
        defaultUser.setObject(lable1.text, forKey: "holdedNumber")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let des1 = SelectConverterView()
        if (segue.identifier == "ShowConverter")
        {
            des1.calculatorHoldedNum = lable1.text
        }
    }
    override func viewWillAppear(animated: Bool) {
        lable1.text = (defaultUser.valueForKey("holdedNumber") as! String)
    }
    
}

