//
//  DatabaseUser.swift
//  Twitimer
//
//  Created by Brais Moure on 22/4/21.
//

import Foundation

struct DatabaseUser: Codable {
        
    let id: String?
    let login: String?
    let displayName: String?
    let broadcasterType: String?
    let descr: String?
    let profileImageUrl: String?
    let offlineImageUrl: String?
    let streamer: Int?
    let schedule: [DatabaseUserSchedule]?
    let followedUsers: [String]?
    
    func toUser() -> User {
        
        let schedule = self.schedule?.map({ (dbSchedule) -> UserSchedule in
            return dbSchedule.toUserSchedule()
        })
        
        return User(id: id, login: login, displayName: displayName, broadcasterType: BroadcasterType(rawValue: broadcasterType ?? ""), descr: descr, profileImageUrl: profileImageUrl, offlineImageUrl: offlineImageUrl, streamer: streamer == 1,schedule: schedule, followedUsers: followedUsers ?? [])
    }
    
}

struct DatabaseUserSchedule: Codable {
    
    var enable: Int?
    var weekDay: Int?
    var date: String?
    var duration: Int?
    var title: String?
    
    func toUserSchedule() -> UserSchedule {
        let weekDayType = WeekdayType(rawValue: weekDay ?? 0) ?? .custom
        let date = date?.toDate()
        return UserSchedule(enable: enable == 1, weekDay: weekDayType, currentWeekDay: weekDayType, date: date ?? Date(), duration: duration ?? 1, title: title ?? "")
    }
    
}
