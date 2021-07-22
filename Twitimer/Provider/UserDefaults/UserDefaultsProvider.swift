//
//  UserDefaultsProvider.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import Foundation

enum UserDefaultsKey: String {
    case token
    case authUser
    case streamers
    case firebaseAuthUid
    case onboarding
    case firstSync
}

final class UserDefaultsProvider {
    
    static private let kDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.kJsonDateFormat
        return dateFormatter
    }()
    
    static func set(key: UserDefaultsKey, value: Any) {
        let standard = UserDefaults.standard
        standard.set(value, forKey: key.rawValue)
        standard.synchronize()
    }
    
    static func setCodable<Element: Codable>(key: UserDefaultsKey, value: Element) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(kDateFormatter)
        do {
            let data = try encoder.encode(value)
            let standard = UserDefaults.standard
            standard.setValue(data, forKey: key.rawValue)
            standard.synchronize()
        } catch let jsonError as NSError {
            debugPrint("JSON encode failed: \(jsonError.localizedDescription)")
        }
    }
    
    static func codable<Element: Codable>(key: UserDefaultsKey) -> Element? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(kDateFormatter)
        do {
            let element = try decoder.decode(Element.self, from: data)
            return element
        } catch let jsonError as NSError {
            debugPrint("JSON decode failed: \(jsonError.localizedDescription)")
        }
        return nil
    }
    
    static func string(key: UserDefaultsKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func bool(key: UserDefaultsKey) -> Bool? {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func remove(key: UserDefaultsKey) {
        let standard = UserDefaults.standard
        standard.removeObject(forKey: key.rawValue)
        standard.synchronize()
    }
    
    // Elimina los UserDefaults del dominio app
    static func clear() {
        let standard = UserDefaults.standard
        standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        standard.synchronize()
    }
    
}
