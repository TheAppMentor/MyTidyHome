//
//  PrashUIControls.swift
//  TidyHome
//
//  Created by Prashanth Moorthy on 11/10/15.
//  Copyright © 2015 Prashanth Moorthy. All rights reserved.
//

import Foundation
import UIKit

class TestView: UIView {
    
    @IBOutlet var theContentView: UIView!
    
    override func awakeFromNib() {
        NSBundle.mainBundle().loadNibNamed("TestView", owner: self, options: nil)
        self.addSubview(theContentView)
        theContentView.backgroundColor = UIColor.redColor()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("TestView", owner: self, options: nil)
        theContentView.frame = frame
        self.addSubview(theContentView)
        theContentView.backgroundColor = UIColor.redColor()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("TestView", owner: self, options: nil)
        self.addSubview(theContentView)
        theContentView.backgroundColor = UIColor.redColor()
    }
}


class PrashCalendarView: UIView {
    
    let thePurpleColor = UIColor(red: (101/255), green: (100/255.0), blue: (164/255.0), alpha: 1.0)

    
    @IBOutlet var theContentView: UIView!
    override func awakeFromNib() {
        NSBundle.mainBundle().loadNibNamed("PrashCalendarView", owner: self, options: nil)
        self.addSubview(theContentView)
        theContentView.backgroundColor = thePurpleColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("PrashCalendarView", owner: self, options: nil)
        self.addSubview(theContentView)
        theContentView.backgroundColor = thePurpleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("PrashCalendarView", owner: self, options: nil)
        theContentView.frame = frame
        self.addSubview(theContentView)
        theContentView.backgroundColor = thePurpleColor

    }
    
    // Set button State. User might have chosen some dates previously (for eg in edit screen).
    // So look at all the buttons in the calendar and set thier state appropriately
    
    func setCalendarButtonStateUsingArray(previousDatesArray : [String]) -> (){
        // This Calendar contains two nested Stacks. SO dig out the buttons from two levels deep.
        
        let theOuterStackView = self.viewWithTag(22) as? UIStackView
        
        for someView in (theOuterStackView?.arrangedSubviews)!{
            if let theInnerStack = someView as? UIStackView{
                for theMayBeButton in theInnerStack.arrangedSubviews{
                    if let aButton = theMayBeButton as? calendarButton{
                        print("We finally found a bloody Calendar Button \(aButton)")
                        if previousDatesArray.contains((aButton.titleLabel?.text)!){
                            aButton.isButtonEnabled = true
                        }
                    }
                }
            }
        
        }

        
        
    }
    
}


class roundButton: UIButton {
    
    var isButtonEnabled = false{
        didSet{
            if isButtonEnabled{
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.backgroundColor = UIColor(red: (80/255.0), green: (209/255.0), blue: (192/255.0), alpha: 1.0)
                })
            }else{
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.frame.width/2
//        self.backgroundColor = UIColor(red: (192.0/255.0), green: (192.0/255.0), blue: (192.0/255.0), a
        self.backgroundColor = UIColor.clearColor()
        self.frame.size.height = self.frame.size.width
        self.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        
     
        self .addTarget(self, action: Selector("buttonChanged"), forControlEvents:UIControlEvents.TouchUpInside)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.width/2
//        self.backgroundColor = UIColor(red: (192.0/255.0), green: (192.0/255.0), blue: (192.0/255.0), alpha: 1.0)
        self.backgroundColor = UIColor.clearColor()
        self.frame.size.height = self.frame.size.width
        self.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        
        
        self .addTarget(self, action: Selector("buttonChanged"), forControlEvents:UIControlEvents.TouchUpInside)

    }
    
    
    func buttonChanged(){
        print("Man the buttons stateChanged")
        if isButtonEnabled{
            isButtonEnabled = false
//            self.backgroundColor = UIColor(red: (192.0/255.0), green: (192.0/255.0), blue: (192.0/255.0), alpha: 1.0)
//            self.backgroundColor = UIColor.clearColor()


        } else if !isButtonEnabled{
            isButtonEnabled = true
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.backgroundColor = UIColor(red: (80/255.0), green: (209/255.0), blue: (192/255.0), alpha: 1.0)
            })
        }
    }
 
    
    /// UIButton subclass that draws a rounded rectangle in its background.
    
    }

public class RoundRectButton: UIButton {
    
    // MARK: Public interface
    
    /// Corner radius of the background rectangle
    public var roundRectCornerRadius: CGFloat = 20 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Color of the background rectangle
    public var roundRectColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    // MARK: Private
    
    private var roundRectLayer: CAShapeLayer?
    
    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: roundRectCornerRadius).CGPath
        shapeLayer.fillColor = roundRectColor.CGColor
        self.layer.insertSublayer(shapeLayer, atIndex: 0)
        self.roundRectLayer = shapeLayer
    }
}

class calendarButton: UIButton {
    
    var isButtonEnabled = false{
        didSet{
            if isButtonEnabled{
                            UIView.animateWithDuration(0.5, animations: { () -> Void in
                                self.backgroundColor = UIColor(red: (80/255.0), green: (209/255.0), blue: (192/255.0), alpha: 1.0)
                            })
            }else{
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
        self.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        self .addTarget(self, action: Selector("buttonChanged"), forControlEvents:UIControlEvents.TouchUpInside)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        self .addTarget(self, action: Selector("buttonChanged"), forControlEvents:UIControlEvents.TouchUpInside)
        
    }
    
    
    func buttonChanged(){
        print("Man the buttons stateChanged")
        if isButtonEnabled{
            isButtonEnabled = false
        } else if !isButtonEnabled{
            isButtonEnabled = true
        }
    }
}


class chooseFrequencyTitle: UIView {
    
    @IBOutlet var theContentView: UIView!
    
    var theTitleLabel : UILabel = UILabel()
    var theCloseButton : UIButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("ChooseFrequencyTitle", owner: self, options: nil)
        theTitleLabel = theContentView.viewWithTag(11) as! UILabel
        theCloseButton = theContentView.viewWithTag(22) as! UIButton
        self.addSubview(theContentView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("ChooseFrequencyTitle", owner: self, options: nil)
        theContentView.frame = frame
        theTitleLabel = theContentView.viewWithTag(11) as! UILabel
        theCloseButton = theContentView.viewWithTag(22) as! UIButton
        self.addSubview(theContentView)
    }
}
