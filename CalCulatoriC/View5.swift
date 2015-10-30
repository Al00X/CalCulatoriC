//
//  View5.swift
//  CalCulatoriC
//
//  Created by Reza Sheikhizadeh on ۹۴/۴/۱۸.
//  Copyright (c) ۱۳۹۴ ه‍.ش. Al00X. All rights reserved.
//

//
//  ViewController.swift
//  SwiftTest
//
//  Created by Reza Sheikhizadeh on ۹۴/۴/۱۶.
//  Copyright (c) ۱۳۹۴ ه‍.ش. Al00X. All rights reserved.
//

import UIKit

class View5: UIViewController {
    
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
    
    @IBOutlet var lableMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var model: String = UIDevice.currentDevice().model
        
        
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var holdD = UILongPressGestureRecognizer(target: self, action: "handleHoldsD:")
        var holdT = UILongPressGestureRecognizer(target: self, action: "handleHoldsT:")
        var holdTheme = UILongPressGestureRecognizer(target: self, action: "handleTheme:")
        
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
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        
        var themeN: Int! = defaultUser.integerForKey("themeNumber")
        var theme: String! = defaultUser.stringForKey("Theme")
        
        var path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
        var dic = NSDictionary(contentsOfFile: path!)
        
        if (themeN != nil && themeN <= dic?.count)
        {
            themeNum = themeN
            
            var path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
            var dic = NSDictionary(contentsOfFile: path!)
            
            var hexColor = dic?.valueForKey("theme" + (themeNum! as NSNumber).stringValue) as? String
            
            for (var i = 1; i < 7; i++)
            {
                var btn = self.view.viewWithTag(i) as? UIButton
                
                btn?.backgroundColor = UIColor(rgba: "#" + hexColor!)
            }
        }
        if (theme != nil)
        {
            if (theme == "Black")
            {
                self.view.backgroundColor = UIColor.blackColor()
                
                for(var i = 10; i < 14; i++)
                {
                    var label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.whiteColor()
                    label?.backgroundColor = UIColor.blackColor()
                }
                for(var i = 14; i < 16; i++)
                {
                    var btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.blackColor()
                }
            }
            else
            {
                self.view.backgroundColor = UIColor.whiteColor()
                
                for(var i = 10; i < 14; i++)
                {
                    var label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.blackColor()
                    label?.backgroundColor = UIColor.whiteColor()
                }
                
                for(var i = 14; i < 16; i++)
                {
                    var btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.whiteColor()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberTouch(sender: UIButton) {
        
        var button = sender
        var num: String! = button.titleLabel?.text
        
        
        if (countElements(lable1.text!) < 15)
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
        }
        else
        {
            lableMessage.text = "Maximum Length"
            
            fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
            fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            
            return
        }
    }
    @IBAction func operatorTouch(sender: UIButton) {
        
        
        var button = sender
        var symbol = button.titleLabel?.text
        
        
        
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
        var first = previewLable.text
        var second = lable1.text
        
        var number1: Double = (first! as NSString).doubleValue
        var number2: Double = (second! as NSString).doubleValue
        var result: Double!
        var symbol = previewSymbol.text
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
                fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
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
        
    }
    
    func update()
    {
        if (lable1.text == "inf")
        {
            lableMessage.text = "Infinity"
            fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
            fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            
            previewLable.text = "0"
            lable1.text = "0"
        }
        if (lable1.text == "Error" || lable1.text == "error")
        {
            lableMessage.text = "Error"
            fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
            fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
            
            previewLable.text = "0"
            lable1.text = "0"
        }
        
        
    }
    
    @IBAction func clearTouch(sender: UIButton)
    {
        lable1.text = "0"
        previewLable.text = "0"
        previewSymbol.text = ""
        firstNumber = ""
        secondNumber = ""
        negative = false
        dot = false
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
    }
    @IBAction func persentTouch(sender: UIButton)
    {
        var num = (lable1.text! as NSString).doubleValue
        num = num / 100
        lable1.text = (num as NSNumber).stringValue
    }
    @IBAction func dotTouch(sender: UIButton)
    {
        if (lable1.text!.rangeOfString(".") == nil)
        {
            if (countElements(lable1.text!) < 14)
            {
                lable1.text = lable1.text! + "."
            }
            else
            {
                lableMessage.text = "Maximum Length"
                
                fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
                fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
                return
            }
        }
        else
        {
            lableMessage.text = "'.' Already Exist"
            
            fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
            fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
        }
        
        
    }
    
    @IBAction func creditTouch(sender: UIButton)
    {
        lableMessage.text = "Al00X - AliSheikhizadeh"
        
        fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
        fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer)
    {
        if (lable1.text == "0" || lable1.text == "" || lable1.text == "-0")
        {
            lableMessage.text = "Cannot Delete"
            
            fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
            fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
        }
        else
        {
            if (countElements(lable1.text!) < 2)
            {
                lable1.text = "0"
            }
            else
            {
                lable1.text = dropLast(lable1.text!)
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
    }
    @IBAction func themesTouch(sender: UIButton)
    {
        lableMessage.text = "Theme Changed"
        
        fadeAnimationLable(1.0, d: 0.5, fadeOut: false, lable: lableMessage)
        fadeAnimationLable(2.0, d: 0.5, fadeOut: true, lable: lableMessage)
        
        themeNum!++
        
        var path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
        var dic = NSDictionary(contentsOfFile: path!)
        
        if (themeNum >= dic?.count)
        {
            themeNum = 0
        }
        NSLog((themeNum! as NSNumber).stringValue)
        var hexColor = dic?.valueForKey("theme" + (themeNum! as NSNumber).stringValue) as? String
        
        for (var i = 1; i < 7; i++)
        {
            var btn = self.view.viewWithTag(i) as? UIButton
            
            btn?.backgroundColor = UIColor(rgba: "#" + hexColor!)
        }
        
        defaultUser.setInteger(themeNum, forKey: "themeNumber")
    }
    
    func handleTheme(sender: UILongPressGestureRecognizer)
    {
        var white = UIColor(rgba: "#FFFFFF")
        var black = UIColor(rgba: "#000000")
        
        if (sender.state == UIGestureRecognizerState.Began)
        {
            if (self.view.backgroundColor == UIColor.whiteColor())
            {
                self.view.backgroundColor = UIColor.blackColor()
                
                for(var i = 10; i < 14; i++)
                {
                    var label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.whiteColor()
                    label?.backgroundColor = UIColor.blackColor()
                }
                for(var i = 14; i < 16; i++)
                {
                    var btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.blackColor()
                    
                    defaultUser.setObject("Black", forKey: "Theme")
                }
            }
            else
            {
                self.view.backgroundColor = UIColor.whiteColor()
                
                for(var i = 10; i < 14; i++)
                {
                    var label = self.view.viewWithTag(i) as? UILabel
                    
                    label?.textColor = UIColor.blackColor()
                    label?.backgroundColor = UIColor.whiteColor()
                }
                
                for(var i = 14; i < 16; i++)
                {
                    var btn = self.view.viewWithTag(i) as? UIButton
                    
                    btn?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    btn?.backgroundColor = UIColor.whiteColor()
                    
                    defaultUser.setObject("White", forKey: "Theme")
                }
            }
        }
    }
    
}

