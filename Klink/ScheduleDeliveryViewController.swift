//
//  ScheduleDeliveryViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 28/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class ScheduleDeliveryViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var scheduleDeliveryButton: UIButton!
    
    @IBOutlet var contentView: UIView!
    
    var selectedDay:Int = 0
    
    ///
    
    @IBOutlet var firstDayTextLabel: KLLabel!
    @IBOutlet var firstDayNumberLabel: KLLabel!
    
    @IBOutlet var secondDayTextLabel: KLLabel!
    @IBOutlet var secondDayNumberLabel: KLLabel!
    
    @IBOutlet var thirdDayTextLabel: KLLabel!
    @IBOutlet var thirdDayNumberLabel: KLLabel!
    
    @IBOutlet var fourthDayTextLabel: KLLabel!
    @IBOutlet var fourtDayNumberLabel: KLLabel!
    
    @IBOutlet var fifthDayTextLabel: KLLabel!
    @IBOutlet var fifthDayNumberLabel: KLLabel!
    
    @IBOutlet var firstDayHolder: UIView!
    @IBOutlet var secondDayHolder: UIView!
    @IBOutlet var thirdDayHolder: UIView!
    @IBOutlet var fourthDayHolder: UIView!
    @IBOutlet var fifthDayHolder: UIView!
    
    ///
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: "ScheduleDeliveryViewController", bundle: nil)
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: "dismissPressed:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        setupContentView()
        setupDayLabels()
        setupDayHolders()
        setupDeliveryButton()
        setDeliveryButtonTitle()
        
        setHolderSelected(selectedDay)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Helper Methods
    
    func dayNameAndNumberForDate(date: NSDate) -> (dayName: String, dayNumber: Int){
        
        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday], fromDate: date)
        let day = components.day
        let weekday = components.weekday
        return (NSDate.weekDayShortName(weekday), day)
    }
    
    func nextDay(date: NSDate) -> NSDate{
        let components = NSDateComponents()
        components.day = 1
//        components.hour = 0

        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func setupContentView() {
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
    }
    
    func setupDayHolders() {
        let tap1 = UITapGestureRecognizer(target: self, action: "holderTapped:")
        firstDayHolder.addGestureRecognizer(tap1)
        firstDayHolder.tag = 0
        
        let tap2 = UITapGestureRecognizer(target: self, action: "holderTapped:")
        secondDayHolder.addGestureRecognizer(tap2)
        secondDayHolder.tag = 1
        
        let tap3 = UITapGestureRecognizer(target: self, action: "holderTapped:")
        thirdDayHolder.addGestureRecognizer(tap3)
        thirdDayHolder.tag = 2
        
        let tap4 = UITapGestureRecognizer(target: self, action: "holderTapped:")
        fourthDayHolder.addGestureRecognizer(tap4)
        fourthDayHolder.tag = 3
        
        let tap5 = UITapGestureRecognizer(target: self, action: "holderTapped:")
        fifthDayHolder.addGestureRecognizer(tap5)
        fifthDayHolder.tag = 4
    }
    
    func resetDayHoldersBackground() {
        firstDayHolder.backgroundColor = UIColor.whiteColor()
        secondDayHolder.backgroundColor = UIColor.whiteColor()
        thirdDayHolder.backgroundColor = UIColor.whiteColor()
        fourthDayHolder.backgroundColor = UIColor.whiteColor()
        fifthDayHolder.backgroundColor = UIColor.whiteColor()
        
        firstDayNumberLabel.textColor = UIColor.blackColor()
        firstDayTextLabel.textColor = UIColor.blackColor()
        
        secondDayNumberLabel.textColor = UIColor.blackColor()
        secondDayTextLabel.textColor = UIColor.blackColor()
        
        thirdDayNumberLabel.textColor = UIColor.blackColor()
        thirdDayTextLabel.textColor = UIColor.blackColor()
        
        fourthDayTextLabel.textColor = UIColor.blackColor()
        fourtDayNumberLabel.textColor = UIColor.blackColor()
        
        fifthDayNumberLabel.textColor = UIColor.blackColor()
        fifthDayTextLabel.textColor = UIColor.blackColor()
    }
    
    func setHolderSelected(index: Int) {
        resetDayHoldersBackground()
        switch index {
        case 0:
            firstDayHolder.backgroundColor = UIColor.kvfKlinkOrangeColor()
            firstDayNumberLabel.textColor = UIColor.whiteColor()
            firstDayTextLabel.textColor = UIColor.whiteColor()
            break
        case 1:
            secondDayHolder.backgroundColor = UIColor.kvfKlinkOrangeColor()
            secondDayNumberLabel.textColor = UIColor.whiteColor()
            secondDayTextLabel.textColor = UIColor.whiteColor()
            break
        case 2:
            thirdDayHolder.backgroundColor = UIColor.kvfKlinkOrangeColor()
            thirdDayNumberLabel.textColor = UIColor.whiteColor()
            thirdDayTextLabel.textColor = UIColor.whiteColor()
            break
        case 3:
            fourthDayHolder.backgroundColor = UIColor.kvfKlinkOrangeColor()
            fourthDayTextLabel.textColor = UIColor.whiteColor()
            fourtDayNumberLabel.textColor = UIColor.whiteColor()
            break
        case 4:
            fifthDayHolder.backgroundColor = UIColor.kvfKlinkOrangeColor()
            fifthDayNumberLabel.textColor = UIColor.whiteColor()
            fifthDayTextLabel.textColor = UIColor.whiteColor()
            break
        default:
            break
        }
    }
    
    func setupDayLabels() {
        firstDayNumberLabel.adjustsFontSizeToFitWidth = true
        let today = NSDate()
        let firstDay = dayNameAndNumberForDate(today)
        firstDayTextLabel.text = "Today"
        firstDayNumberLabel.text = "\(firstDay.dayNumber)"
        firstDayTextLabel.sizeToFit()
        
        let secondDate = nextDay(today)
        let secondDay = dayNameAndNumberForDate(secondDate)
        secondDayTextLabel.text = secondDay.dayName
        secondDayNumberLabel.text = "\(secondDay.dayNumber)"
        secondDayTextLabel.sizeToFit()
        
        let thirdDate = nextDay(secondDate)
        let thirdDay = dayNameAndNumberForDate(thirdDate)
        thirdDayTextLabel.text = thirdDay.dayName
        thirdDayNumberLabel.text = "\(thirdDay.dayNumber)"
        thirdDayTextLabel.sizeToFit()
        
        let fourthDate = nextDay(thirdDate)
        let fourthDay = dayNameAndNumberForDate(fourthDate)
        fourthDayTextLabel.text = fourthDay.dayName
        fourtDayNumberLabel.text = "\(fourthDay.dayNumber)"
        fourthDayTextLabel.sizeToFit()
        
        let fifthDate = nextDay(fourthDate)
        let fifthDay = dayNameAndNumberForDate(fifthDate)
        fifthDayTextLabel.text = fifthDay.dayName
        fifthDayNumberLabel.text = "\(fifthDay.dayNumber)"
        fifthDayTextLabel.sizeToFit()
    }
    
    func setupDeliveryButton() {
        scheduleDeliveryButton.layer.cornerRadius = 5.0
        scheduleDeliveryButton.layer.masksToBounds = true
        scheduleDeliveryButton.backgroundColor = UIColor.kvfKlinkOrangeColor()
    }
    
    func setDeliveryButtonTitle() {
        scheduleDeliveryButton.setTitle("  Send today, as soon as possible.  ", forState: .Normal)
    }
    
    // MARK: - User Actions
    
    func holderTapped(tap: UITapGestureRecognizer) {
        setHolderSelected((tap.view?.tag)!)
    }
    
    // ---- UIViewControllerTransitioningDelegate methods
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return SlideFromBottomPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return SlideFromBottomAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return SlideFromBottomAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }

    @IBAction func dismissPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let touchLocation = touch.locationInView(self.view)
        return !CGRectContainsPoint(self.contentView.frame, touchLocation)
    }


}
