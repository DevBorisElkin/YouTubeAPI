//
//  DateHelpers.swift
//  YouTubeAPI
//
//  Created by test on 11.08.2022.
//

import Foundation

class DateHelpers{
    
    static func getDateNow() -> Date {
        return Date()
    }
    
    // Convert ISO 8601 RFC 3339 String to date
    static func getDateFromRfc3339(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: dateString)
    }
    
    static func getTimeSincePublication(from dateString: String) -> String {
        let date = getDateFromRfc3339(from: dateString)
        guard let date = date else {
            return "Error formatting date"
        }
        return Date().prettyOffsetFrom(date: date)
    }
}

extension Date {

    public func offsetFrom(date: Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours

        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    public func prettyOffsetFrom(date: Date) -> String {

        let comparationComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(comparationComponents, from: date, to: self)

        if let yearsDiff = difference.year, yearsDiff > 0 {
            let result: String = "\(yearsDiff)" + (yearsDiff > 1 ? " years ago" : " year ago")
            return result
        }
        
        if let monthsDiff = difference.month, monthsDiff > 0 {
            let result: String = "\(monthsDiff)" + (monthsDiff > 1 ? " months ago" : " month ago")
            return result
        }
        
        if let daysDiff = difference.day, daysDiff > 0 {
            
            if daysDiff.isMultiple(of: 7){
                let weeksDiff = daysDiff % 7
                let result: String = "\(weeksDiff)" + (weeksDiff > 1 ? " weeks ago" : " week ago")
                return result
            }
            
            let result: String = "\(daysDiff)" + (daysDiff > 1 ? " days ago" : " day ago")
            return result
        }
        
        if let hoursDiff = difference.hour, hoursDiff > 0 {
            let result: String = "\(hoursDiff)" + (hoursDiff > 1 ? " hours ago" : " hour ago")
            return result
        }
        
        if let minutesDiff = difference.minute, minutesDiff > 0 {
            let result: String = "\(minutesDiff)" + (minutesDiff > 1 ? " minutes ago" : " minute ago")
            return result
        }
        
        return "Moments ago"
    }
}
