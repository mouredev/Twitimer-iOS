//
//  User.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

struct Users: Codable {
    
    let data: [User]?
    
}

struct User: Codable {
    
    let id: String?
    let login: String?
    let displayName: String?
    let broadcasterType: BroadcasterType?
    let descr: String?
    let profileImageUrl: String?
    let offlineImageUrl: String?
    
    // Optional
    var streamer: Bool?
    var schedule: [UserSchedule]?
    var followedUsers: [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case id, login, streamer, schedule, followedUsers
        case displayName = "display_name"
        case broadcasterType = "broadcaster_type"
        case descr = "description"
        case profileImageUrl = "profile_image_url"
        case offlineImageUrl = "offline_image_url"
    }
    
    func toJSON() -> [String:Any] {
        
        var JSON: [String:Any] = [DatabaseField.id.rawValue:id ?? "",
                                  DatabaseField.login.rawValue:login ?? "",
                                  DatabaseField.displayName.rawValue:displayName ?? "",
                                  DatabaseField.broadcasterType.rawValue:broadcasterType?.rawValue ?? "",
                                  DatabaseField.descr.rawValue:descr ?? "",
                                  DatabaseField.profileImageUrl.rawValue:profileImageUrl ?? "",
                                  DatabaseField.offlineImageUrl.rawValue:offlineImageUrl ?? "",
                                  DatabaseField.streamer.rawValue:(streamer ?? false) ? 1 : 0,
                                  DatabaseField.followedUsers.rawValue:followedUsers ?? []]
        
        JSON[DatabaseField.schedule.rawValue] = scheduleToJSON()
        
        return JSON
    }
    
    func scheduleToJSON() -> [[String:Any]] {
        
        var scheduleJSON: [[String:Any]] =  []
        schedule?.forEach { (userSchedule) in
            var updateUserSchedule = userSchedule
            scheduleJSON.append(updateUserSchedule.toJSON())
        }
        return scheduleJSON
    }
    
    // Actualiza el calendario del usuario a fechas disponibles a futuro
    mutating func updateToAvailableSchedule() {
                
        let calendar = Calendar.current
        let todayDate = Date()
        
        schedule?.forEach({ daySchedule in
            
            let realWeekdayType = daySchedule.date.getWeekDayType(originalWeekDay: daySchedule.weekDay.rawValue)
            
            if daySchedule.weekDay != .custom, let realWeekday = realWeekdayType.toDateWeekday() {
                
                let date = daySchedule.date
                let hour = calendar.component(.hour, from: date)
                let minute = calendar.component(.minute, from: date)
                
                let currentDate = todayDate.next(realWeekday, considerToday: true, referenceDate: date, duration: daySchedule.duration)
                if let updatedDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate) {
                    schedule?[daySchedule.weekDay.rawValue].date = updatedDate
                    schedule?[daySchedule.weekDay.rawValue].currentWeekDay = realWeekdayType
                }
            }
        })
    }
    
}

// Empty User init
extension User {
    init() {
        self.init(id: nil, login: nil, displayName: nil, broadcasterType: nil, descr: nil, profileImageUrl: nil, offlineImageUrl: nil, streamer: nil, schedule: nil, followedUsers: nil)
    }
}

struct UserSchedule: Codable, Equatable {
    
    var enable = false
    var weekDay: WeekdayType
    var currentWeekDay: WeekdayType
    var date: Date
    var duration: Int
    var title: String
    
    mutating func toJSON() -> [String:Any] {
        
        // HACK: Al guardar un horario establecemos la fecha local del usuario para ese día de la semana. Esto nos servirá para calcular con qué día de la semana se corresponde en caso de cambio horario.
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        
        if let nextWeekday = weekDay.toDateWeekday(), let day = currentDateComponents.day, let month = currentDateComponents.month, let year = currentDateComponents.year {

            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            components.timeZone = TimeZone.current
            components.day = day
            components.month = month
            components.year = year
            
            if let updatedDate = calendar.date(from: components) {
                date = updatedDate
            }
            
            date = date.next(nextWeekday, considerToday: true)
        }
        
        return [DatabaseField.enable.rawValue:enable ? 1 : 0,
                DatabaseField.weekDay.rawValue:weekDay.rawValue,
                DatabaseField.date.rawValue:date.toJSON(),
                DatabaseField.duration.rawValue:duration,
                DatabaseField.title.rawValue:title]
    }
    
    // Obtiene la fecha ficticia más próxima al día de la semana
    func weekDate() -> Date {

        if let nextWeekday = currentWeekDay.toDateWeekday() {
            let nextDate = date.next(nextWeekday, considerToday: true, referenceDate: date, duration: duration)
            var finishDate = nextDate
            finishDate.addTimeInterval(60 * 60 * Double(duration))
            if Date() < finishDate {
                return finishDate
            }
            return date.next(nextWeekday, considerToday: false)
        }
        return date
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date).uppercaseFirst()
    }
    
}

enum BroadcasterType: String, Codable {
    case partner, affiliate, none = ""
}

enum WeekdayType: Int, Codable, CaseIterable {
    
    case custom = 0
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var name: String {
        return "schedule.\(self.rawValue)".localized
    }
    
    func toDateWeekday() -> Date.Weekday? {
        switch self {
        case .custom:
            return nil
        case .monday:
            return .monday
        case .tuesday:
            return .tuesday
        case .wednesday:
            return .wednesday
        case .thursday:
            return .thursday
        case .friday:
            return .friday
        case .saturday:
            return .saturday
        case .sunday:
            return .sunday
        }
    }
    
}
