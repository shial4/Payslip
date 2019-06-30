//
//  Date.swift
//  App
//
//  Created by Szymon Lorenz on 29/6/19.
//

import Foundation

extension Calendar {
    static func new() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }
}

extension DateFormatter {
    static func new(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }
}

extension String {
    public func date(format: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        return DateFormatter.new(format).date(from: self)
    }
}                   
extension Date {
    public func toString(_ format: String = "yyyy-MM-dd'T'HH:mm:ss") -> String {
        return DateFormatter.new(format).string(from: self)
    }
    
    public func weekDay() -> Int? {
        
        return Calendar.new().dateComponents([.weekday], from: self).weekday
    }
    
    public static func interval(from: Date?, to: Date?, in component: Calendar.Component) -> Int? {
        guard let from = from, let to = to else { return nil }
        return Calendar.new().dateComponents([component], from: from, to: to).value(for: component)
    }
    
    public func add(interval: Int, in component: Calendar.Component) -> Date? {
        return Calendar.new().date(byAdding: component, value: interval, to: self)
    }
    
    public func setTo6PM() -> Date? {
        return Calendar.new().date(bySettingHour: 18, minute: 0, second: 0, of: self)
    }
}
