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
    
    static var pastLocations: Set<String> = []
    
    
    static func generateDateObjectArray() -> [HomeCalendarCell] {
        let weekArr = createWeekArray()
        let oneYearAgoInSeconds = -31536000.0
        let secondsInDay = 86400.0
        let startDate = Date.init(timeIntervalSinceNow: oneYearAgoInSeconds)
        
        var retArr: [HomeCalendarCell] = [HomeCalendarCell(startDate)]
        
        for i in 1...730 {
            let constant = oneYearAgoInSeconds + (Double(i) * secondsInDay * 1.0)
            var currCell = HomeCalendarCell(Date.init(timeIntervalSinceNow: constant))
            currCell.events = loadEventsForCell(currCell)
            
            for event in currCell.events {
                if event.location != nil && event.location != "" {
                    pastLocations.insert(event.location!)
                }
            }

            
            
            if i >= 365 && i < 372 {
                currCell.weather = Weather.forecast[i - 365]
            }
            retArr.append(currCell)
        }
        return retArr
    }
    
    static func createWeekArray() -> [Date]{
        var weekArr = [Date()]
        var currentDate = Date()
        var i = 1
        while i < 7 {
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            weekArr.append(nextDate!)
            currentDate = nextDate!
            i += 1
        }
        return weekArr
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
        dateFormatter.dateFormat = "MMMM d"
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
    
    func year() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func month() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func hourAndMinute() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func dateDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd EE"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func dayMonthDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func nearestHour() -> Date {
        return Date(timeIntervalSinceReferenceDate:
                        (timeIntervalSinceReferenceDate / 3600.0).rounded(.toNearestOrEven) * 3600.0)
    }
    
    func add15Minutes() -> Date {
        return Calendar.current.date(byAdding: .minute, value: 15, to: self)!
    }
    
    func subtract15Minutes() -> Date {
        return Calendar.current.date(byAdding: .minute, value: -15, to: self)!
    }
    
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }

    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
                Calendar.current.dateComponents([.year,.month], from: self))!
    }

    func getAllDays() -> [Date] {
        var days = [Date]()

        let calendar = Calendar.current

        let range = calendar.range(of: .day, in: .month, for: self)!

        var day = firstDayOfTheMonth()
        
        var numDays = range.count
        
        while day.dayOfWeek() != "SUN" {
            day = Calendar.current.date(byAdding: .day, value: -1, to: day)!
            numDays += 1
        }

        for _ in 1...numDays {
            days.append(day)
            day.addDays(n: 1)
        }
        
        if day.dayOfWeek() != "SUN" {
            while day.dayOfWeek() != "SAT" {
                days.append(day)
                day.addDays(n: 1)
            }
            days.append(day)
        }
        
//        while day.dayOfWeek() != "SAT" {
//            days.append(day)
//            day.addDays(n: 1)
//        }
//        days.append(day)

        return days
    }
}

struct HomeCalendarCell {
    var dayOfWeek: String
    var dateNumber: String
    var monthAndYear: String
    var date: Date
    var events: [EKEvent]
    var weather: Forecast? = nil
    var dayFacts: DayFacts? = nil
    var monthDate: MonthDate
    var id: String = ""
    
    init(_ date: Date) {
        dayOfWeek = date.dayOfWeek()!
        dateNumber = date.dateNumber()!
        monthAndYear = date.monthAndYear()!
        self.date = date
        events = []
        monthDate = HomeCalendarCell.generateMonthDate(date)
    }
    
    static func generateMonthDate(_ date: Date) -> MonthDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let monthString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "d"
        let dateString = dateFormatter.string(from: date)
        return MonthDate(monthString, dateString)
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
