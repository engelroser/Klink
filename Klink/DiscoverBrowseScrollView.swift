//
//  DiscoverBrowseScrollView.swift
//  Klink
//
//  Created by Mobile App Dev on 09/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

@objc protocol DiscoverBrowseScrollViewDelegate {
    optional func discoverBrowseScrollButtonPressed(scrollView: UIScrollView, atIndex index:Int)
}

class DiscoverBrowseScrollView: UIScrollView {

    var categories:[CategoryModel] = []
    let padding:CGFloat = 10
    var discoverBrowseScrollDelegate:DiscoverBrowseScrollViewDelegate?
    var contentHeight:CGFloat = 0.0
    var contentView:UIView?
    var buttons:[UIButton] = []
    var indicators:[UIView] = []
    var showIndicator = false
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commontInit()
    }
    
    func commontInit() {
        delaysContentTouches = true
    }
    
    func addCategories(categories:[CategoryModel], selectedIndex: Int) {
        
        
        if categories.count == 0 {
            return
        }
        
        self.selectedIndex = selectedIndex
        
        var x:CGFloat = 0
        contentView = UIView() // frame: CGRectMake(self.frame.size.width, 0, 0, self.frame.size.height)
        
        self.contentHeight = self.frame.size.height
        
        self.categories = categories
        
        for c in categories {
            let title = c.name
            let button = createButton(title, xOffset: x)
            buttons.append(button)
            contentView!.addSubview(button)
            
            button.autoMatchDimension(.Height, toDimension: .Height, ofView: contentView!)
            button.autoSetDimension(.Width, toSize: button.frame.size.width)
            button.autoPinEdge(.Leading, toEdge: .Leading, ofView: contentView!, withOffset: button.frame.origin.x)
            button.autoPinEdge(.Top, toEdge: .Top, ofView: contentView!)
            
            x = button.frame.origin.x + button.frame.size.width + 20
        }
        
        let firstButton = buttons[0]
        
        let screenSize = UIScreen.mainScreen().bounds
        self.addSubview(contentView!)
        contentView?.autoSetDimension(.Width, toSize: x)
        contentView?.autoMatchDimension(.Height, toDimension: .Height, ofView: self)
        contentView?.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 0)
        contentView?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self, withOffset: 0)
        contentView?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self, withOffset: screenSize.width/2 - firstButton.frame.size.width)
        contentView?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self, withOffset: -40.0)
    }
    
    private func textWidth(text: String) -> CGFloat{
        let font = UIFont(name: "Gotham-Bold", size: 18.0)
        let attributes: [String : AnyObject] = [NSFontAttributeName: font!]
        let temp: NSString = text.uppercaseString as NSString
        let size = temp.sizeWithAttributes(attributes)
        
        return size.width
    }
    
    private func createButton(title:String, xOffset: CGFloat) -> UIButton {
        let width = textWidth(title) + padding
        let button:UIButton = UIButton(frame: CGRectMake(xOffset, 0, width, contentHeight))
        button.setTitle(title.uppercaseString, forState: .Normal)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.backgroundColor = UIColor.clearColor()
        let font = UIFont(name: "Gotham-Bold", size: 18.0)
        button.titleLabel?.font = font
        
        let indicator = UIView(frame: CGRectMake(0, button.frame.size.height - 1, button.frame.size.width, 1))
        button.addSubview(indicator)
        indicator.autoPinEdge(.Leading, toEdge: .Leading, ofView: button)
        indicator.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: button)
        indicator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: button)
        indicator.autoSetDimension(.Height, toSize: 2.0)
        
        indicator.backgroundColor = UIColor.kvfKlinkOrangeColor()
        indicator.hidden = true
        
        indicators.append(indicator)
        
        return button
    }
    
    func showIndicator(flag: Bool) {
        self.showIndicator = flag
        for view in indicators {
            if indicators[selectedIndex] == view {
                view.hidden = !flag
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let transparent = UIColor.clearColor().CGColor
        let opaque = UIColor.whiteColor().CGColor
        let mainLayer = CALayer()
        mainLayer.frame = self.bounds
        
        let l1 = CAGradientLayer()
        l1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
        l1.startPoint = CGPointMake(0.0, 0.5);
        l1.endPoint = CGPointMake(1.0, 0.5);
        l1.colors = [transparent, opaque, opaque, transparent];
        
        l1.locations = [ 0, 0.2 , 0.8, 1]
        mainLayer.addSublayer(l1)
        self.layer.mask = mainLayer
    }
    
    func buttonPressed(button: UIButton) {
        print("CATEGORY PRESSED")
        let title = button.titleLabel!.text
        
        for c in categories {
            if c.name.lowercaseString == title?.lowercaseString {
                let index = (categories).indexOf(c)
                if showIndicator {
                    let indicator = indicators[index!]
                    for view in indicators {
                        view.hidden = true
                    }
                    indicator.hidden = false
                }
                discoverBrowseScrollDelegate?.discoverBrowseScrollButtonPressed!(self, atIndex: index!)
                return
            }
        }
    }
    
    func setSelectedCategory(index: Int) {
        let indicator = indicators[index]
        for view in indicators {
            view.hidden = true
        }
        indicator.hidden = false
        
        let button = buttons[index]
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        let x = (contentView?.frame.origin.x)! +  button.frame.origin.x + button.frame.size.width - screenWidth/2
        
        self.setContentOffset(CGPointMake(x,0), animated: true)
    }
}
