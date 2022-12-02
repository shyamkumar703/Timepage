//
//  Calendar.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/15/21.
//

import Foundation
import EventKit

var store = EKEventStore()

class Cal {
    static func generateDateObjectArray() -> [HomeCalendarCell] {
        let oneYearAgoInSeconds = -31536000.0
        let secondsInDay = 86400.0
        let startDate = Date.init(timeIntervalSinceNow: oneYearAgoInSeconds)
        
        var retArr: [HomeCalendarCell] = [HomeCalendarCell(startDate)]
        
        for i in 1...730 {
            let constant = oneYearAgoInSeconds + (Double(i) * secondsInDay * 1.0)
            var currCell = HomeCalendarCell(Date.init(timeIntervalSinceNow: constant))
            currCell.events = loadEventsForCell(currCell)
            retArr.append(currCell)
        }
        
        return retArr
    }
    
    static func compareDate(date1:Date, date2:Date) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    static func requestAccess() {
        store.requestAccess(to: .event, completion: {granted, error in
        })
    }
    
    static func loadEventsForCell(_ hcc: HomeCalendarCell) -> [EKEvent] {
        let calendar = Calendar.current
        var events: [EKEvent] = []
        let predicate = store.predicateForEvents(withStart: calendar.startOfDay(for: hcc.date), end: calendar.date(bySettingHour: 23, minute: 59, second: 59, of: hcc.date)!, calendars: nil)
        let dateEvents = store.events(matching: predicate)
        events += dateEvents
        return events
    }
    
   
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).uppercased()
        // or use capitalized(with: locale) if you want
    }
    
    func fullDayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func monthDateAndYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func dateNumber() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    func monthAndYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let firstString = dateFormatter.string(from: self).uppercased()
        return firstString.insertSeparator(" ", atEvery: 1)
    }
}

struct HomeCalendarCell {
    var dayOfWeek: String
    var dateNumber: String
    var monthAndYear: String
    var date: Date
    var events: [EKEvent]
    
    init(_ date: Date) {
        dayOfWeek = date.dayOfWeek()!
        dateNumber = date.dateNumber()!
        monthAndYear = date.monthAndYear()!
        self.date = date
        events = []
    }
}

extension String {

    func insertSeparator(_ separatorString: String, atEvery n: Int) -> String {
        guard 0 < n else { return self }
        return self.enumerated().map({String($0.element) + (($0.offset != self.count - 1 && $0.offset % n ==  n - 1) ? "\(separatorString)" : "")}).joined()
    }

    mutating func insertedSeparator(_ separatorString: String, atEvery n: Int) {
        self = insertSeparator(separatorString, atEvery: n)
    }
}
