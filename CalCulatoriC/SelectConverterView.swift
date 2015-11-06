//
//  SelectConverterView.swift
//  CalCulatoriC
//
//  Created by Reza Sheikhizadeh on ۹۴/۴/۲۴.
//  Copyright (c) ۱۳۹۴ ه‍.ش. Al00X. All rights reserved.
//

import UIKit

class SelectConverterView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UnitSelectionDelegate  {
    
    var converterNames = ["Angle","Area", "Data","Energy","Flow","Length","Power","Pressure","Speed","Temperature","Time","Volume","Weight"]
    var selectedConvert: String!
    var defaultUser = NSUserDefaults.standardUserDefaults()
    var negative: Bool = false
    var fromUnit: String?
    var toUnit: String?
    var firstUnitClicked: Bool? = true
    var selectedFromUnitView: String! = nil
    internal var calculatorHoldedNum: String!
    

    
    @IBOutlet var calculatorButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var unitButton2: UIButton!
    @IBOutlet var unitButton1: UIButton!
    @IBOutlet var fromLable: UILabel!
    @IBOutlet var toLable: UILabel!
    @IBOutlet var negativeButton: UIButton!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        let swipeGestureL = UISwipeGestureRecognizer(target: self, action: "swipeHandle:")
        let swipeGestureR = UISwipeGestureRecognizer(target: self, action: "swipeHandle:")
        
        swipeGestureL.direction = .Left
        swipeGestureR.direction = .Right
        
        fromLable.addGestureRecognizer(swipeGestureL)
        fromLable.addGestureRecognizer(swipeGestureR)
        
        if let _ = defaultUser.valueForKey("savedFrom") {
            fromUnit = defaultUser.valueForKey("savedFrom") as? String
        } else {
            fromUnit = nil
        }
        
        if let _ = defaultUser.valueForKey("savedTo") {
            toUnit = defaultUser.valueForKey("savedTo") as? String
        } else {
            toUnit = nil
        }
        
        
        fromLable.text = "0"
        toLable.text = "0"
        
        firstUnitClicked = defaultUser.valueForKey("firstSelect") as? Bool
        
        fromLable.text = defaultUser.valueForKey("holdedNumber") as? String
        
        let themeN: Int! = defaultUser.integerForKey("themeNumber")
        let theme: String! = defaultUser.stringForKey("Theme")
        
        let path = NSBundle.mainBundle().pathForResource("Themes", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        
        let pathW = NSBundle.mainBundle().pathForResource("Calculator2Convert_White", ofType: "png")
        let pathB = NSBundle.mainBundle().pathForResource("Calculator2Convert_Black", ofType: "png")
        let imgW: UIImage! = UIImage(contentsOfFile: pathW!)
        let imgB: UIImage! = UIImage(contentsOfFile: pathB!)
        
        if (themeN != nil && themeN <= dic?.count)
        {
            let hexColor = dic?.valueForKey("theme" + (themeN as NSNumber).stringValue) as? String
            
            for (var i = 20; i < 23; i++)
            {
                let btn = self.view.viewWithTag(i) as? UIButton
                
                btn?.backgroundColor = UIColor(rgba: "#" + hexColor!)
            }
        }
        if (theme != nil)
        {
            if (theme == "Black")
            {
                calculatorButton.setBackgroundImage(imgB, forState: .Normal)
                self.view.backgroundColor = UIColor.blackColor()
                
                fromLable.textColor = UIColor.whiteColor()
                fromLable.backgroundColor = UIColor.blackColor()
                toLable.textColor = UIColor.whiteColor()
                toLable.backgroundColor = UIColor.blackColor()
            }
            else
            {
                calculatorButton.setBackgroundImage(imgW, forState: .Normal)
                self.view.backgroundColor = UIColor.whiteColor()
                
                fromLable.textColor = UIColor.blackColor()
                fromLable.backgroundColor = UIColor.whiteColor()
                toLable.textColor = UIColor.blackColor()
                toLable.backgroundColor = UIColor.whiteColor()
            }
        }
        
        if let _ = defaultUser.valueForKey("selectedConvert") {
            selectedConvert = defaultUser.valueForKey("selectedConvert") as! String
        } else {
            selectedConvert = "Angle"
        }
        
        var row: Int!
        for (var i: Int = 0; i < converterNames.count; i++)
        {
            let now: String = converterNames[i]
            
            if (now == selectedConvert)
            {
                row = i
                continue
            }
        }
//        if (calculatorHoldedNum != nil)
//        {
//            fromLable.text = calculatorHoldedNum
//        }else{
//            fromLable.text = "0"
//        }
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
        
        pickerView.selectRow(row, inComponent: 0, animated: true)
        
        unitAbrev()
        
        convert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return converterNames.count
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attString: NSAttributedString!
        
        if (component == 0)
        {
            
        
            attString = NSAttributedString(string: converterNames[row], attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        
            
        }
        return attString
    }
    func swipeHandle(sender: UISwipeGestureRecognizer)
    {
        if (fromLable.text != "0")
        {
            fromLable.text = String(fromLable.text!.characters.dropLast())
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedConvert = converterNames[row]
        
        if (selectedConvert == "Temperature")
        {
            negativeButton.enabled = true
        }
        else
        {
            negativeButton.enabled = false
        }
        
        defaultUser.setObject(selectedConvert, forKey: "selectedConvert")
        unitConfigure1()
        unitConfigure2()
        unitAbrev()
        convert()
        
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    
    @IBAction func numberTouch(sender: UIButton)
    {
        let button = sender
        let num: String! = button.titleLabel?.text
        
        
        if (fromLable.text?.characters.count) < 15
        {
            if (fromLable.text == "0" || fromLable.text == "")
            {
                fromLable.text = num
            }
            else if (fromLable.text == "-0")
            {
                fromLable.text = "-" + num
            }
            else
            {
                fromLable.text = fromLable.text! + num
            }
        }
        else
        {
            return
        }
        
        convert()
        
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    
    @IBAction func dotTouch(sender: AnyObject)
    {
        if (fromLable.text!.rangeOfString(".") == nil)
        {
            if (fromLable.text?.characters.count < 14)
            {
                fromLable.text = fromLable.text! + "."
            }
        }
        
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    
    @IBAction func negativeTouch(sender: AnyObject)
    {
        if (negative == false)
        {
            negative = true
            
            fromLable.text = "-" + fromLable.text!
        }
        else
        {
            fromLable.text = fromLable.text?.stringByReplacingOccurrencesOfString("-", withString: "")
            negative = false
        }
        
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    
    @IBAction func flipTouch(sender: AnyObject)
    {
        let from: String! = fromLable.text
        let to: String! = toLable.text
        let fromSign: String! = unitButton1.titleLabel?.text
        let toSign: String! = unitButton2.titleLabel?.text
        let unit1: String! = fromUnit
        let unit2: String! = toUnit
        
        fromLable.text = to
        toLable.text = from
        unitButton1.setTitle(toSign, forState: UIControlState.Normal)
        unitButton2.setTitle(fromSign, forState: UIControlState.Normal)
        fromUnit = unit2
        toUnit = unit1
        
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    
    @IBAction func clearTouch(sender: AnyObject)
    {
        fromLable.text = "0"
        toLable.text = "0"
        negative = false
        
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
        convert()
    }
    
    func unitAbrev()
    {
        
        
        let path = NSBundle.mainBundle().pathForResource("abrev", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        if (fromUnit == nil)
        {
            unitConfigure1()
        }
        if (toUnit == nil)
        {
            unitConfigure2()
        }
        if (selectedFromUnitView != nil)
        {
            if (firstUnitClicked == true)
            {
                fromUnit = selectedFromUnitView
            }else
            {
                toUnit = selectedFromUnitView
            }
            selectedFromUnitView = nil
        }
//        let key1 = fromUnit
//        let key2 = toUnit
        let signF: AnyObject? = dict?.valueForKey(fromUnit!)
        let signT: AnyObject? = dict?.valueForKey(toUnit!)
        
        unitButton1.setTitle((signF as! String), forState: UIControlState.Normal)
        unitButton2.setTitle((signT as! String), forState: UIControlState.Normal)
        
        defaultUser.setObject(fromUnit, forKey: "savedFrom")
        defaultUser.setObject(toUnit, forKey: "savedTo")

    }
    
    func convert()
    {
        let path = NSBundle .mainBundle().pathForResource(selectedConvert, ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!)
        
        let stringfactorF = dic?.valueForKey(fromUnit!) as? String
        let stringfactorT = dic?.valueForKey(toUnit!) as? String
        let factorF = (stringfactorF! as NSString).doubleValue
        let factorT = (stringfactorT! as NSString).doubleValue
        var convertresult: Double! = (fromLable.text! as NSString).doubleValue
        
        if (selectedConvert == "Temperature")
        {
            if (fromUnit == "Celsius")
            {
                if (toUnit == "Fahrenheit")
                {
                    convertresult = (convertresult * 9/5) + 32
                    
                }
                else if (toUnit == "Kelvin")
                {
                    convertresult = convertresult * factorT
                    convertresult = convertresult + 273.15
                }
            }
            else if (fromUnit == "Fahrenheit")
            {
                if (toUnit == "Celsius")
                {
                    convertresult = (convertresult - 32) * 5/9
                }
                else if (toUnit == "Kelvin")
                {
                    convertresult = convertresult * 0.556
                    convertresult = convertresult + 255.372
                }
            }
            else
            {
                if (toUnit == "Celsius")
                {
                    convertresult = convertresult * -1
                    convertresult = convertresult + -273.15
                }
                else if (toUnit == "Fahrenheit")
                {
                    convertresult = convertresult * 0.555556
                    convertresult = convertresult + 1.8
                }
            }
            
        }
        else
        {
            convertresult = convertresult * factorF
            convertresult = convertresult / factorT
        }
        toLable.text = (convertresult as NSNumber).stringValue
        
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    
    @IBAction func unit1Clicked(sender: AnyObject)
    {
        firstUnitClicked = true
        defaultUser.setBool(true, forKey: "firstSelect")
    }
    @IBAction func unit2Clicked(sender: AnyObject)
    {
        firstUnitClicked = false
        defaultUser.setBool(false, forKey: "firstSelect")
    }
    
    func unitConfigure1()
    {
        switch (selectedConvert)
        {
        case "Angle":
            fromUnit = "Degrees"
            break;
        case "Area":
            fromUnit = "Meters²"
            break;
        case "Data":
            fromUnit = "Byte"
            break;
        case "Flow":
            fromUnit = "Liter/Hour"
            break;
        case "Speed":
            fromUnit = "Kilometers/Hr"
            break;
        case "Time":
            fromUnit = "Seconds"
            break;
        case "Pressure":
            fromUnit = "Pascals"
            break;
        case "Volume":
            fromUnit = "Centimeters³"
            break;
        case "Temperature":
            fromUnit = "Celsius"
            break;
        case "Weight":
            fromUnit = "Kilograms"
            break;
        case "Power":
            fromUnit = "Watts"
            break;
        case "Energy":
            fromUnit = "Calories"
            break;
        case "Length":
            fromUnit = "Meters"
            break;
            
        default:
            break;
        }
    }
    func unitConfigure2()
    {
        switch (selectedConvert)
        {
        case "Angle":
            toUnit = "Mils"
            break;
        case "Area":
            toUnit = "Inches²"
            break;
        case "Data":
            toUnit = "Kilobyte"
            break;
        case "Flow":
            toUnit = "Liter/Sec"
            break;
        case "Speed":
            toUnit = "Meters/Sec"
            break;
        case "Time":
            toUnit = "Minutes"
            break;
        case "Pressure":
            toUnit = "Torr"
            break;
        case "Volume":
            toUnit = "Meters³"
            break;
        case "Temperature":
            toUnit = "Fahrenheit"
            break;
        case "Weight":
            toUnit = "Grams"
            break;
        case "Power":
            toUnit = "Kilowatts"
            break;
        case "Energy":
            toUnit = "Joules"
            break;
        case "Length":
            toUnit = "Inches"
            break;
            
        default:
            break;
        }
    }
    
//    func update()
//    {
//        defaultUser.setObject(fromUnit, forKey: "savedFrom")
//        defaultUser.setObject(toUnit, forKey: "savedTo")
//    }
    
    func unitSelectionChanged(newUnit: String) {
        selectedFromUnitView = newUnit
        unitAbrev()

        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination1 = segue.destinationViewController as! SelectUnitView
        
        if (segue.identifier == "toSelectUnitView")
        {
            destination1.firstUnitSelected = true
        }
        destination1.parentVC = self
        destination1.delegate = self
    }
    @IBAction func backButtonTouch(sender: AnyObject) {
        let destination2 = View6()
        destination2.convertHoldedNum = toLable.text
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func toCalculatorTouch(sender: UIButton)
    {
        defaultUser.setValue(toLable.text, forKey: "holdedNumber")
    }
    override func viewWillAppear(animated: Bool) {
        convert()
    }
    
}
