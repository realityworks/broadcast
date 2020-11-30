//
//  DateFormatter+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 30/11/20.
//

import Foundation

extension DateFormatter {
    static let appDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    static let appDateTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    static let iso8601DateTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return df
    }()
    
    static let apiDateTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        
        df.calendar = Calendar(identifier: .iso8601)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXX"
        
        return df
    }()
}
