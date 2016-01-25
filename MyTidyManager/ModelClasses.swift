//
//  ModelClasses.swift
//  TidyHome
//
//  Created by Prashanth Moorthy on 24/01/16.
//  Copyright © 2016 Prashanth Moorthy. All rights reserved.
//

import Foundation

enum Day : Int{
    
    var allValues : [String] {
        return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }
    
    case Sunday = 0, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    
    func nextDay(after : Day) -> Day{
        return Day(rawValue: (after.rawValue + 1))!
    }
    
    func nextPossibleDayFrom(theCleaningDays : [Day]) -> Day{
        var daysPast : [Int] = []
        var daysRemaining : [Int] = []
        
        for anIndex in 0..<self.rawValue{
            daysPast.append(anIndex)
        }
        
        for anIndex in self.rawValue..<7{
            daysRemaining.append(anIndex)
        }
        
        // First check theDays Remaining Array
        for aDay in daysRemaining{
            print(theCleaningDays)
            print(self)
            if theCleaningDays.contains(Day(rawValue: aDay)!){
                return Day(rawValue: aDay)!
            }
        }
        
        // Then Check the past Days Array
        for aDay in daysPast{
            if theCleaningDays.contains(Day(rawValue: aDay)!){
                return Day(rawValue: aDay)!
            }
        }
        return Day.Sunday
    }
    
}

enum CleaningFrequency {
    case OnceDaily
    case OnceWeekly
    case OnceMonthly
    case OnSpecificDays (cleaningDays : [Day])
    case OnSpecificDates (cleaningDates : [Int])
}

enum CleaningStatus {
    case Cleaned (lastCleanedDate : NSDate)
    case Overdue (lastCleanedDate : NSDate)
    case Deleted (onDate : NSDate)
}

struct CleaningHistory {
    var cleanedDate : NSDate
}

struct Member {
    var name = "self"
}


struct DateCalculator {
    static let oneDayTimeInterval : Double = 24 * 60 * 60
    static let oneWeekTimeInterval : Double = 24 * 60 * 60 * 7
    static let oneMonthTimeInterval : Double = 24 * 60 * 60 * 31
    
    static var tomorrow : NSDate {
        return NSDate().dateByAddingTimeInterval(oneDayTimeInterval)
    }
    
    func getDayForDate(theDate : NSDate) -> Day{
        let theDateF = NSDateFormatter()
        theDateF.dateFormat = "EEEE"
        
        switch theDateF.stringFromDate(theDate){
        case "Monday" : return Day.Monday
        case "Tuesday" : return Day.Tuesday
        case "Wednesday" : return Day.Wednesday
        case "Thursday" : return Day.Thursday
        case "Friday" : return Day.Friday
        case "Saturday" : return Day.Saturday
        case "Sunday" : return Day.Sunday
        default :
            print("This is the Default Case Man")
        }
        return Day.Sunday
    }
}

// Class : Item
class Item {
    
    var description : String {
        return self.name
    }
    
    var name : String = ""
    var cleaningFrequency : CleaningFrequency = .OnceDaily
    var cleaningHistory : [CleaningHistory] = []
    var assignedTo : Member!
    var lastCleanedDate : NSDate? = nil
    var notes : String = ""
    weak var belongsToRoom : Room!
    
    // Calculate the Next Cleaning Due Date.
    var nextCleaningDueDate : NSDate? {
        switch cleaningFrequency {
            
        case .OnceDaily :
            return (lastCleanedDate?.dateByAddingTimeInterval(DateCalculator.oneDayTimeInterval))!
            
        case .OnceWeekly :
            return (lastCleanedDate?.dateByAddingTimeInterval(DateCalculator.oneWeekTimeInterval))!
            
        case .OnceMonthly :
            let cal = NSCalendar.currentCalendar()
            let nextDate = cal.dateByAddingUnit(.Month, value: 1, toDate: lastCleanedDate!, options: [])
            return nextDate!
            
        case .OnSpecificDates(let cleaningDates) :
            
            let theCalendar = NSCalendar.currentCalendar()
            
            let todayDate = theCalendar.components([.Day], fromDate: NSDate())
            
            if cleaningDates.contains(todayDate.day){ return NSDate() }
            
            var datesPast : [Int] = []
            var datesRemaining : [Int] = []
            
            for anIndex in 1..<todayDate.day{
                datesPast.append(anIndex)
            }
            
            for anIndex in todayDate.day..<32{
                datesRemaining.append(anIndex)
            }
            
            // First check theDays Remaining Array
            for aDay in datesRemaining{
                if cleaningDates.contains(aDay){
                    let aCalendar = NSCalendar.currentCalendar()
                    var dateComponenets = NSDateComponents()
                    dateComponenets = aCalendar.components([.Year,.Month], fromDate: NSDate())
                    dateComponenets.day = aDay
                    let theFinalDate = aCalendar.dateFromComponents(dateComponenets)
                    return theFinalDate
                }
            }
            
            // Then Check the past Days Array
            for aDay in datesPast{
                if cleaningDates.contains(aDay){
                    let aCalendar = NSCalendar.currentCalendar()
                    var dateComponenets = NSDateComponents()
                    dateComponenets = aCalendar.components([.Year,.Month], fromDate: NSDate())
                    dateComponenets.month += 1
                    dateComponenets.day = aDay
                    let theFinalDate = aCalendar.dateFromComponents(dateComponenets)
                    return theFinalDate
                }
            }
            
        case .OnSpecificDays(let cleaningDays) :
            
            // If the item is to be cleaned on only specific days, we need to figure out the next cleaning day. For eg : They guy might only want to clean on a Sunday, then, regardless of how long back the guy cleaned the Item, we need to check when the next possible cleaning date is (Sunday) and report it to him.
            
            // Find Out Which Day the Item was last cleaned on.
            let lastCleanedDay = DateCalculator().getDayForDate(lastCleanedDate!)
            
            // Check the next day in cleaningDays Array
            let theNextCleaningDay = lastCleanedDay.nextPossibleDayFrom(cleaningDays)
            
            // How many Days between today and next cleaning Day?
            let numberOfDays = (theNextCleaningDay.rawValue - lastCleanedDay.rawValue)
            
            // Finally the Date to be cleand on next.
            let theFinalDate = NSDate(timeIntervalSinceNow: Double(numberOfDays * 24 * 60 * 60))
            return theFinalDate
        }
        return nil
    }
    
    var itemStatus : Bool {
        // Check if the
        if let theLastCleanedDate = lastCleanedDate{
            //            if theLastCleanedDate.timeIntervalSinceNow {
            //
            //            }
           // NSDate.timeIntervalSinceDate(theLastCleanedDate)
        }
        
        return true
    }
}

class Room {
    var name = ""
    var itemList : [Item]?
}




class ItemCatalog {
    
    static let sharedInstance = ItemCatalog()
    
    var dataHasChanged : Bool = false {
        didSet{
            if dataHasChanged == true{
                dataHasChanged = false
                NSNotificationCenter.defaultCenter().postNotificationName("DataHasChanged", object: nil)
            }
        }
    }
    
    var theItemsArray : [Item] = []
    
    func addNewItem(theItem : Item) -> Bool{
        
        // Check if the item with that name already exists.
        
        
        theItemsArray.insert(theItem, atIndex: 0)
        dataHasChanged = true

        return true
    }
    
    func allItems() -> [Item]{
        return theItemsArray
    }
    
    func removeItem(theItem : Item) -> Bool{
        var theResult = false
        for (anIndex,anItem) in theItemsArray.enumerate(){
            // Prashanth : Need a more robust check here.
            if anItem.name == theItem.name{
                theItemsArray.removeAtIndex(anIndex)
                dataHasChanged = true
                theResult = true
            }
        }
        return theResult
    }
    
    
    init(){
        theItemsArray = createItems()
    }
    
    
    // Create List of Items here
    
    func createItems() -> [Item]{
        let theItem1 = Item()
        theItem1.name = "Commode"
        //theItem1.cleaningFrequency = .OnSpecificDays(cleaningDays: [Day.Tuesday,Day.Saturday])
        theItem1.cleaningFrequency = .OnSpecificDates(cleaningDates: [05,15,20,23])
        theItem1.cleaningHistory = []
        theItem1.assignedTo = Member(name: "Self")
        theItem1.notes = "This is a very important item to be cleaned very often."
        theItem1.belongsToRoom = Room()
        theItem1.lastCleanedDate = NSDate()
        theItem1.nextCleaningDueDate
        
        
        let theItem2 = Item()
        theItem2.name = "Television"
        theItem2.cleaningFrequency = .OnSpecificDays(cleaningDays : [Day.Friday])
        theItem2.cleaningHistory = []
        theItem2.assignedTo = Member(name: "Self")
        theItem2.notes = "This is the Freaking TV man!"
        theItem2.belongsToRoom = Room()
        theItem2.lastCleanedDate = NSDate()
        
        
        let theItem3 = Item()
        theItem3.name = "Dining Table"
        theItem3.cleaningFrequency = .OnceDaily
        theItem3.cleaningHistory = []
        theItem3.assignedTo = Member(name: "Self")
        theItem3.notes = "This is the Dining Table Man"
        theItem3.belongsToRoom = Room()
        theItem3.lastCleanedDate = NSDate()
        
        
        let theItem4 = Item()
        theItem4.name = "Gas Stove"
        theItem4.cleaningFrequency = .OnSpecificDates(cleaningDates: [10,20,30])
        theItem4.cleaningHistory = []
        theItem4.assignedTo = Member(name: "Self")
        theItem4.notes = "This is the Cooking Counter Man"
        theItem4.belongsToRoom = Room()
        theItem4.lastCleanedDate = NSDate()
        
        
        let theItemsArrary = [theItem1,theItem2,theItem3,theItem4]
        
        return theItemsArrary
        
    }
    
}