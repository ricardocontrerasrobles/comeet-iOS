//
//  Date+API.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

extension Date {
    
    static func fromISO8601(string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
    
    func stringISO8601() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    func displayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.is24HoursFormat ? "HH':'mm' 'MM'/'dd'/'yyyy" : "h':'mm' 'MM'/'dd'/'yyyy a"
        return formatter.string(from: self)
    }
    
    func displayStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM'/'dd'/'yyyy"
        return formatter.string(from: self)
    }
    
    func displayStringHourMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.is24HoursFormat ? "HH':'mm" : "h':'mm a"
        return formatter.string(from: self)
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay())
    }
    
    func nextWeek() -> Date? {
        var components = DateComponents()
        components.day = 7
        return Calendar.current.date(byAdding: components, to: startOfDay())
    }
    
    static var is24HoursFormat : Bool  {
        
        let formatter = DateFormatter()
        
        formatter.locale    = Locale.autoupdatingCurrent
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        let dateString = formatter.string(from: Date())
        
        if dateString.contains(formatter.amSymbol) || dateString.contains(formatter.pmSymbol) {
            return false
        }
        
        return true
    }
    
    static func dateFrom(sliderValue: Float, date: Date) -> Date {
        var hours = Int(sliderValue / 60)
        if hours >= 24 {
            hours -= 24
        }
        let minutes = Int(sliderValue.truncatingRemainder(dividingBy: 60))
        
        var components = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.hour = hours
        components.minute = minutes
        return NSCalendar.current.date(from: components) ?? date
    }
    
    func changeYearMonthDay(newDate: Date) -> Date {
        
        let hours = Calendar.current.component(.hour, from: self)
        let minutes = Calendar.current.component(.minute, from: self)
        
        var components = NSCalendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newDate)
        components.hour = hours
        components.minute = minutes
        return NSCalendar.current.date(from: components) ?? newDate
        
    }
}

