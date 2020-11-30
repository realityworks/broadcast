//
//  Date+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 30/11/20.
//

import Foundation

extension Date {
    
    /// Computed property that explicitly defines that the date should be now based on the system clock.
    /// In order to avoid any confusing about the initial state of a Date instance, this makes the definition clearer.
    static var now: Date {
        Date(timeIntervalSinceNow: 0)
    }
    
    /// Used to encode the createdDateUtc being sent as a query parameter when using paged APIs.
    /// - Returns: encoded Date
    func asISO8601String() -> String {
        DateFormatter.iso8601DateTimeFormatter.string(from: self)
    }
    
    /// Used to encode the createdDateUtc being sent as a query parameter when using paged APIs.
    /// - Returns: encoded Date
    func asAPIString() -> String {
        DateFormatter.apiDateTimeFormatter.string(from: self)
    }
    
    static func timeAgo(from: Date, to: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.allowsFractionalUnits = true
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        
        let timeComponentsString = formatter.string(from: from, to: to)
        return String(format: timeComponentsString?
            .components(separatedBy: ",")
            .first ?? "", locale: .current)
    }
    
    func timeAgo() -> String {
        return Self.timeAgo(from: self, to: Date())
    }
   
    func friendlyDisplay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, HH:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return String(format: formatter.string(from: self), locale: .current)
    }
}
