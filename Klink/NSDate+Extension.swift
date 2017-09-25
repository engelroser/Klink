//
//  NSDate+Extension.swift
//  Klink
//
//  Created by Mobile App Dev on 28/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation

extension NSDate {
    
    
    class func weekDayShortName(weekday: Int) -> String{

        switch weekday {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            break
        }
        
        return ""
    }
    
    class func localizedString(date: NSDate!) -> String! {
        let localizedString = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        return localizedString
    }
    
}
