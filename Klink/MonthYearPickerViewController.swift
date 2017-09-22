//
//  MonthYearPickerViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 20/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol MonthYearPickerDelegate {
    func monthYearPicker(controller: MonthYearPickerViewController, didSelectDate date:String?)
}

class MonthYearPickerViewController: UIViewController, UIViewControllerTransitioningDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var containerView: UIView!
    
//    var months:[String] = []
    let months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]
    
    var years:[String] = []
    
    var delegate:MonthYearPickerDelegate?
    
    init() {
        super.init(nibName: "MonthYearPickerViewController", bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        
        setupYears()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setupYears() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Year, fromDate: date)
        let year = components.year
        
//        debugPrint("Current year: \(year)")
        
        for i in year...(year + 12) {
            years.append(String(i))
        }
        
//        debugPrint("Years: \(years)")
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
    
    // MARK: - UIPickerViewDataSource
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return months.count
        }
        return years.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return months[row]
        }
        return years[row]
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func okPressed(sender: AnyObject) {
//        debugPrint("Selected: \(months[pickerView.selectedRowInComponent(0)]), \(years[pickerView.selectedRowInComponent(1)])")
        
        let m = String(format: "%02d", arguments: [pickerView.selectedRowInComponent(0) + 1])
        let y = String(format: "%02d", arguments: [(Int(years[pickerView.selectedRowInComponent(1)])! % 2000)])
        
        let date = "\(m)/\(y)"
        delegate?.monthYearPicker(self, didSelectDate: date)
    }
    
}
