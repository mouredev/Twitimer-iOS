//
//  FirebaseRDBService.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import Foundation
import FirebaseDatabase

enum DatabaseField: String {
    case users, streamers // Schemes
    case id, login, displayName, broadcasterType, descr, profileImageUrl, offlineImageUrl // User
    case streamer
    case schedule, enable, weekDay, date, duration, title // Schedule
    case followedUsers
    case settings, onHolidays, discord, youtube, twitter, instagram, tiktok // Settings
}

final class FirebaseRDBService {
    
    // Initialization
    static let shared = FirebaseRDBService()
    
    // Properties
    
    private let usersRef = Database.database().reference(withPath: DatabaseField.users.rawValue)
    private let streamersRef = Database.database().reference(withPath: DatabaseField.streamers.rawValue)
    
    // MARK: Services
    
    func save(user: User) {

        if let login = user.login {
            if user.streamer ?? false {
                streamersRef.child(login).setValue(user.toJSON())
                usersRef.child(login).removeValue()
            } else {
                usersRef.child(login).setValue(user.toJSON())
                streamersRef.child(login).removeValue()
            }
        }
    }
    
    func saveSchedule(user: User) {

        if let login = user.login {
            streamersRef.child(login).child(DatabaseField.schedule.rawValue).setValue(user.scheduleToJSON())
        }
    }
    
    func saveSettings(user: User) {

        if let login = user.login {
            streamersRef.child(login).child(DatabaseField.settings.rawValue).setValue(user.settingsToJSON())
        }
    }

    func search(query: String, success: @escaping (_ users: [User]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {

        let validQuery = query.removeFirebaseInvalidCharacters().lowercased()
        if validQuery.isEmpty {
            success(nil)
            return
        }
        
        streamersRef.child(validQuery).getData { (error, snapshot) in
            if let error = error {
                failure(error)
            } else if snapshot.exists(), let value = snapshot.value {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let dbUser = try JSONDecoder().decode(DatabaseUser.self, from: jsonData)
                    success([dbUser.toUser()])
                } catch let error {
                    failure(error)
                }
            } else {
                success(nil)
            }
        }
    }
    
    func user(user: User, forceStreamer: Bool = false, success: @escaping (_ user: User) -> Void, failure: @escaping (_ error: Error?) -> Void) {
    
        if let login = user.login {
            ((forceStreamer || (user.streamer ?? false)) ? streamersRef : usersRef).child(login).getData { (error, snapshot) in
                if let error = error {
                    failure(error)
                } else if snapshot.exists(), let value = snapshot.value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                        let dbUser = try JSONDecoder().decode(DatabaseUser.self, from: jsonData)
                        success(dbUser.toUser())
                    } catch let error {
                        failure(error)
                    }
                } else {
                    failure(nil)
                }
            }
        } else {
            failure(nil)
        }
    }
    
    func streamers(ids: [String], completion: @escaping (_ streamers: [User]?) -> Void) {

        var finishedRequests = 0
        var streamers: [User]?
        
        ids.forEach({ (login) in
            streamersRef.child(login).getData { (error, snapshot) in
                if snapshot.exists(), let value = snapshot.value {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                        let dbUser = try JSONDecoder().decode(DatabaseUser.self, from: jsonData)
                        if streamers == nil { streamers = [] }
                        streamers?.append(dbUser.toUser())
                    } catch { }// Continue
                }
                finishedRequests += 1
                if finishedRequests == ids.count {
                    
                    // HACK: Se actualizan las fechas del calendario para que correspondan con las actuales
                     if streamers != nil {
                        for (index, _) in streamers!.enumerated() {
                            streamers![index].updateToAvailableSchedule()
                        }
                    }
                    
                    completion(streamers)
                }
            }
        })
    }
    
    func saveFollowedUsers(user: User) {

        if let login = user.login {
            ((user.streamer ?? false) ? streamersRef : usersRef).child(login).child(DatabaseField.followedUsers.rawValue).setValue(user.followedUsers)
        }
    }
    
    func delete(user: User, success: @escaping () -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        if let login = user.login {
            ((user.streamer ?? false) ? streamersRef : usersRef).child(login).removeValue { error, _ in
                if let error = error {
                    failure(error)
                } else {
                    success()
                }
            }
        } else {
            failure(nil)
        }
    }
    
}
