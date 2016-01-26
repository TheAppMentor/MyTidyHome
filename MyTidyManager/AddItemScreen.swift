//
//  AddRoomScreen.swift
//  TidyHome
//
//  Created by Prashanth Moorthy on 11/10/15.
//  Copyright © 2015 Prashanth Moorthy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddItemVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var theTextFieldItemTitle: UITextField!
    @IBOutlet weak var theLabelSubItems: UILabel!
    @IBOutlet weak var theLabelAssignedTO: UILabel!
    @IBOutlet weak var theLabelRepeatFrequency: UILabel!
    @IBOutlet weak var theLabelFrequencyDates: UILabel!
    @IBOutlet weak var theAddRoomStackView: UIView!
    @IBOutlet weak var theAddSubItemsStackView: UIView!
    @IBOutlet weak var theAssignedtoStackView: UIView!
    @IBOutlet weak var thePickFrequencyStackView: UIView!
    @IBOutlet weak var theAddRoomButtom: UIButton!
    
    var theRoomName : String = ""
    
    var theFrequencyChosen : String = ""{
        didSet{
            theLabelRepeatFrequency.text = theFrequencyChosen
            theFrequencyItemsChosen = []
        }
    }
    
    var theFrequencyItemsChosen : Array<String> = []{
        didSet{
            var theJoiner = ","
            self.theLabelFrequencyDates.text = ""
            
            print("theFrequencyChosen is \(theFrequencyItemsChosen)")
            
            for theString in theFrequencyItemsChosen{
                if theFrequencyItemsChosen.first == theString{
                    theJoiner = ""
                }else{
                    theJoiner = ","
                }
                self.theLabelFrequencyDates.text = self.theLabelFrequencyDates.text! + theJoiner + theString
            }
        }
    }
    
    
    var chooseFrequencyButtonStack : UIStackView = UIStackView()
    var theChooseFrequencyView = UIView()
    var theDayListView = UIView()
    var theChooseFrequencyTitle = chooseFrequencyTitle()
    var theDaysOfWeekStack = UIStackView()
    var dimView = UIView()
    var theCalendar = PrashCalendarView()
    
    let thePurpleColor = UIColor(red: (186.0/255), green: (119.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    let theGreenColor = UIColor(red: (80/255.0), green: (209/255.0), blue: (192/255.0), alpha: 1.0)
    let theGrayColor = UIColor(red: (192.0/255.0), green: (192.0/255.0), blue: (192.0/255.0), alpha: 1.0)
    
    
    let theFont = UIFont(name: "Avenir-Light", size: 17.0)
    let theFontSmall = UIFont(name: "Avenir-Light", size: 12.0)
    
    var dailyButton = UIButton()
    var weeklyButton = UIButton()
    var monthlyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.toolbarHidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBAction func newItemAdded(sender : UIButton){
        print("Now we will add the Item to DB")

        let newItem = Item()
        newItem.name = theTextFieldItemTitle.text!
        newItem.lastCleanedDate = nil
        
        switch self.theFrequencyChosen {
        case "Daily" :
            CleaningFrequency.OnceDaily
        case "OnceWeekly" :
            CleaningFrequency.OnceWeekly
        case "OnceMonthly" :
            CleaningFrequency.OnceMonthly
        default :
            print("Some Error Man.")
        }
        
        newItem.cleaningFrequency = .OnceDaily
        newItem.assignedTo = Member()

        if ItemCatalog.sharedInstance.addNewItem(newItem){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                print("Item added Successfully")            
            })
        }
        print(ItemCatalog.sharedInstance.allItems())
    }
    
    
    @IBAction func changeFrequency(sender: AnyObject) {
        
        // Dim the background view
        dimView = UIView(frame: view.frame)
        dimView.backgroundColor = UIColor.blackColor()
        dimView.alpha = 0.6
        view.addSubview(dimView)
        
        // Set up the Main Choose Frequency View
        
        theChooseFrequencyView = UIView(frame: CGRectMake(0, view.frame.height, view.frame.width, view.frame.height/2))
        view.addSubview(theChooseFrequencyView)
        theChooseFrequencyView.backgroundColor = thePurpleColor
        
        // Add a title to the choose frequency view.
        
        theChooseFrequencyTitle = chooseFrequencyTitle(frame: CGRectMake(0, 0, theChooseFrequencyView.frame.width, theChooseFrequencyView.frame.height/5))
        
        theChooseFrequencyTitle.theCloseButton.addTarget(self, action: "dismissFreqView", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //        theChooseFrequencyTitle = UIView(frame: CGRectMake(0, 0, theChooseFrequencyView.frame.width, theChooseFrequencyView.frame.height/5))
        
        theChooseFrequencyView.addSubview(theChooseFrequencyTitle)
        
        // Add Daily Monthly Weekly Frequency Button
        
        // Create a Choose Frequency StackView
        chooseFrequencyButtonStack = UIStackView(frame: CGRectMake(1, (theChooseFrequencyTitle.frame.origin.y + theChooseFrequencyTitle.frame.height + 1), (theChooseFrequencyView.frame.width - 2) , theChooseFrequencyTitle.frame.height))
        chooseFrequencyButtonStack.axis = UILayoutConstraintAxis.Horizontal
        chooseFrequencyButtonStack.distribution = UIStackViewDistribution.FillEqually
        chooseFrequencyButtonStack.spacing = 1
        
        dailyButton = UIButton(frame: CGRectMake(0, 100, theChooseFrequencyView.frame.width/3, theChooseFrequencyView.frame.height/5))
        dailyButton.backgroundColor = thePurpleColor
        dailyButton.setTitle("Daily", forState: .Normal)
        dailyButton.titleLabel?.font = theFont
        
        weeklyButton = UIButton(frame: CGRectMake(0, 100, theChooseFrequencyView.frame.width/3, theChooseFrequencyView.frame.height/5))
        weeklyButton.backgroundColor = thePurpleColor
        weeklyButton.setTitle("Weekly", forState: .Normal)
        weeklyButton.addTarget(self, action:"showDailyList:", forControlEvents:UIControlEvents.TouchUpInside)
        weeklyButton.titleLabel?.font = theFont
        
        monthlyButton = UIButton(frame: CGRectMake(0, 100, theChooseFrequencyView.frame.width/3, theChooseFrequencyView.frame.height/5))
        monthlyButton.backgroundColor = thePurpleColor
        monthlyButton.setTitle("Monthly", forState: .Normal)
        monthlyButton.titleLabel?.font = theFont
        monthlyButton.addTarget(self, action:"showCalendar:", forControlEvents:UIControlEvents.TouchUpInside)
        
        
        chooseFrequencyButtonStack.addArrangedSubview(dailyButton)
        chooseFrequencyButtonStack.addArrangedSubview(weeklyButton)
        chooseFrequencyButtonStack.addArrangedSubview(monthlyButton)
        
        theChooseFrequencyView.addSubview(chooseFrequencyButtonStack)
        
        UIView.animateWithDuration(1.0, delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 14,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                self.theChooseFrequencyView.frame.origin.y -= (self.theChooseFrequencyTitle.frame.height + self.chooseFrequencyButtonStack.frame.height)
            }) { (theSuccess) -> Void in
                if (theSuccess){
                    print("OK man this worked")
                }
        }
    }
    
    func showDailyList(sender : UIButton) -> (){
        
        // First Diaable the button. To prever user from clicking on it again.
        sender.enabled = false
        
        let tempPreviousChoiceArray = theFrequencyItemsChosen
        
        // Save the Chosen Value
        print("Here I chose the value Prashanth .. its \(sender.titleLabel?.text)")
        theFrequencyChosen = (sender.titleLabel?.text)!
        
        sender.backgroundColor = thePurpleColor
        dailyButton.backgroundColor = theGrayColor
        monthlyButton.backgroundColor = theGrayColor
        
        theDayListView = UIView(frame: CGRectMake(chooseFrequencyButtonStack.frame.origin.x, chooseFrequencyButtonStack.frame.origin.y + chooseFrequencyButtonStack.frame.height, chooseFrequencyButtonStack.frame.width, chooseFrequencyButtonStack.frame.height))
        
        theChooseFrequencyView.addSubview(theDayListView)
        theDayListView.backgroundColor = thePurpleColor
        
        theDaysOfWeekStack = UIStackView(frame: CGRectMake(0, 0, theDayListView.frame.width, theDayListView.frame.height))
        theDaysOfWeekStack.axis = UILayoutConstraintAxis.Horizontal
        theDaysOfWeekStack.distribution = UIStackViewDistribution.FillEqually
        theDaysOfWeekStack.alignment = UIStackViewAlignment.Center
        theDaysOfWeekStack.spacing = 2
        
        
        for theDay in ["SUN","MON","TUE","WED","THU","FRI","SAT"]{
            let tempButton1 = roundButton()
            tempButton1.setTitle(theDay, forState: UIControlState.Normal)
            tempButton1.titleLabel?.font = theFontSmall
            
            if tempPreviousChoiceArray.contains(theDay){
                tempButton1.isButtonEnabled = true
            }
            
            theDaysOfWeekStack.addArrangedSubview(tempButton1)
        }
        
        theDayListView.addSubview(theDaysOfWeekStack)
        
        
        UIView.animateWithDuration(0.5, delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 14,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                self.theChooseFrequencyView.frame.origin.y -= self.theDayListView.frame.height
            }) { (theSuccess) -> Void in
                if (theSuccess){
                    print("OK man this worked")
                }
        }
        
    }
    
    func showCalendar(sender : UIButton)->(){
        
        sender.backgroundColor = thePurpleColor
        dailyButton.backgroundColor = theGrayColor
        weeklyButton.backgroundColor = theGrayColor
        
        // Save the previously chosen values (if Any) to display to the user.
        let tempPreviousChoiceArray = theFrequencyItemsChosen
        
        // Save the Chosen Value
        theFrequencyChosen = (sender.titleLabel?.text)!
        
        //Lets create the calendar view first
        theCalendar = PrashCalendarView(frame: CGRectMake(
            chooseFrequencyButtonStack.frame.origin.x,
            (chooseFrequencyButtonStack.frame.origin.y),
            chooseFrequencyButtonStack.frame.width,
            view.frame.width))
        
        theCalendar.setCalendarButtonStateUsingArray(tempPreviousChoiceArray)
        
        _ = theCalendar.viewWithTag(22)?.frame.height
        
        theChooseFrequencyView.addSubview(theCalendar)
        
        UIView.animateWithDuration(0.5, delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 14,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                self.theChooseFrequencyView.frame.origin.y -= (self.theCalendar.frame.height - self.chooseFrequencyButtonStack.frame.height/2 - self.theChooseFrequencyTitle.frame.height)
                
            }) { (theSuccess) -> Void in
                if (theSuccess){
                    print("OK man this worked")
                }
        }
        
    }
    
    func dismissFreqView() -> (){
        // Look at all the buttons in WeekList or Month List and look at which days are pickec.
        
        if theFrequencyChosen == "Daily"{
         self.theFrequencyChosen = "Daily"
        }
        
        if theFrequencyChosen == "Weekly"{
            for theViews in theDaysOfWeekStack.arrangedSubviews{
                if let aButton = theViews as? roundButton{
                    if aButton.isButtonEnabled{
                        print("Selected Day is :  \((aButton.titleLabel?.text)!)")
                        self.theFrequencyItemsChosen.append((aButton.titleLabel?.text)!)
                    }
                }
            }
        }
        
        if theFrequencyChosen == "Monthly"{
            
            let theStack = theCalendar.viewWithTag(22) as! UIStackView
            
            for theViews in theStack.arrangedSubviews{
                if let theInnerStack = theViews as? UIStackView{
                    for someView in theInnerStack.arrangedSubviews{
                        if let aButton = someView as? calendarButton{
                            if aButton.isButtonEnabled{
                                print("Selected Day is :  \((aButton.titleLabel?.text)!)")
                                self.theFrequencyItemsChosen.append((aButton.titleLabel?.text)!)
                            }
                        }
                        
                    }
                }
            }
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.theChooseFrequencyView.frame.origin.y = self.view.frame.height
            }) { (success) -> Void in
                if success{
                    self.dimView.removeFromSuperview()
                    self.theChooseFrequencyView.removeFromSuperview()
                }
        }
    }
    
    // Text Field Delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.returnKeyType = UIReturnKeyType.Done
        if textField.text == "Add Room"{
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = "Add Room"
        }else{
            theRoomName  = textField.text!
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func dismisstheKeyboard(sender: UITextField) {
        //        sender.becomeFirstResponder()
        if sender.text == "" {
            sender.text = "Add Room"
        }else{
            theRoomName = sender.text!
        }
        sender.resignFirstResponder()
    }
    
    @IBAction func dismissAddItemsScreen(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("Dismissing without adding an Item")
        }
    }
    
    
    // Text Field Validation
    func validateItemName(theItemName : String?) -> Bool{
        if let aItemName = theItemName {
            guard !(aItemName.isEmpty) else {return false}
            guard !(aItemName == "Item Name") else {return false}
            return true
        }
        
        return false
    }
    
    
}

