//
//  UserScheduleSegment.swift
//  Twitimer
//
//  Created by Brais Moure on 2/7/21.
//

import Foundation

struct UserSchedules: Decodable {
    
    let data: UserSchedulesSegments?
    
}

struct UserSchedulesSegments: Decodable {
    
    let segments: [UserScheduleSegment]?
    
}

struct UserScheduleSegment: Decodable {
    
    let id: String?
    let startTime: String?
    let endTime: String?
    let title: String?
    let isRecurring: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case startTime = "start_time"
        case endTime = "end_time"
        case isRecurring = "is_recurring"
    }
    
}
