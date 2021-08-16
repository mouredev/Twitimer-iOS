//
//  DateExtension.swift
//  Twitimer
//
//  Created by Brais Moure on 21/4/21.
//

import Foundation

extension Date {
    
    func toJSON() -> String {
        let formatter = DateFormatter()
        //formatter.locale = Constants.kLocale
        //formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        return formatter.string(from: self)
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false, referenceDate: Date? = nil, duration: Int? = nil, save: Bool = true) -> Date {
        
        let dayName = weekday.rawValue
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        let calendar = Calendar(identifier: .gregorian)
        
        let dayOfWeek = calendar.component(.weekday, from: self)
        if considerToday && dayOfWeek == searchWeekdayIndex {
            if let referenceDate = referenceDate, let duration = duration, referenceDate.addingTimeInterval(60 * 60 * Double(duration)) > self {
                return referenceDate
            } else if Date() <= self.addingTimeInterval(60 * 60 * Double(duration ?? 0))
                        || self.addingTimeInterval(60 * 60 * Double(duration ?? 0)) <= Date()
                        || save && self > Date() {
                return self
            }
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self, matching: nextDateComponent, matchingPolicy: .nextTime, direction: .forward)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Constants.kDefaultLocale
        let list = calendar.weekdaySymbols
        return list // 7 valores: Sunday, Monday... Saturday
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    func getWeekDayType(originalWeekDay: Int?) -> WeekdayType {
        
        if let originalWeekDay = originalWeekDay, originalWeekDay != WeekdayType.custom.rawValue {
            return weekdayType()
        }
        return .custom
    }
    
    func weekdayType() -> WeekdayType {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Constants.kDefaultLocale
        let currentDateComponents = calendar.dateComponents([.weekday], from: self)
        if let weekday = currentDateComponents.weekday {
            switch weekday {
            case 1: return .sunday
            case 2: return .monday
            case 3: return .tuesday
            case 4: return .wednesday
            case 5: return .thursday
            case 6: return .friday
            case 7: return .saturday
            default: break
            }
        }
        return .custom
    }
    
}
