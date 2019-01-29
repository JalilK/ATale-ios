//
//  Date+Extensions.swift
//  ATaleIos
//
//  Created by jalil.kennedy on 1/29/19.
//  Copyright © 2019 jalil.kennedy. All rights reserved.
//

import Foundation

extension Date {
    enum StringFormat: String {
        case MMddyy = "MM/dd/yy"
        case HHmm = "HH:mm"
        case Mddyy = "M/dd/yy"
        case MMMMdyyyy = "MMMM d, yyyy"
        case MMMMdyyyyHHmm = "MMMM d, yyyy HH:mm"
        case MMMMdyyyyhmma = "MMMM d, yyyy h:mm a"
        case MMMyyyy = "MMM yyyy"
        case MMMMyyyy = "MMMM yyyy"
        case yyyyMMdd = "yyyy-MM-dd"
        case ISO8601 = "yyyy-MM-dd'T'HH:mm:ss"
        case RFC822 = "EEE, dd MMM yyyy hh:mm:ss xxxx"
    }

    func toString(withFormat format: StringFormat, inTimeZone timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US")

        return dateFormatter.string(from: self)
    }
}
