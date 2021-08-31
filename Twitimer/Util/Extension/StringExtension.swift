//
//  StringExtension.swift
//  Twitimer
//
//  Created by Brais Moure on 20/4/21.
//

import SwiftUI

extension String {
    
    var url: URL? {
        return URL(string: self)
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var localizedKey: LocalizedStringKey {
        return LocalizedStringKey(self)
    }
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        var date = formatter.date(from: self)
        if date == nil {
            formatter.locale = Constants.kDefaultLocale
            date = formatter.date(from: self)
        }
        return date
    }
    
    func toRFC3339Date() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Constants.kDefaultLocale
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        var date = formatter.date(from: self)
        if date == nil {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
            date = formatter.date(from: self)
        }
        return date
    }
    
    func uppercaseFirst() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func removeFirebaseInvalidCharacters() -> String {
        return replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "#", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
    }
    
    func removeSocialInvalidCharacters() -> String {
        return replacingOccurrences(of: "@", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
    
}
