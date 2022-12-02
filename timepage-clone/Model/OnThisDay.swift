//
//  OnThisDay.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/16/21.
//

import Foundation
import Alamofire

class OnThisDay {
    
    static var facts: [DayFacts] = []
    
    static func generateMonthDateObjects() -> [MonthDate] {
        let oneYearAgoInSeconds = -31536000.0
        let secondsInDay = 86400.0
//        let startDate = Date.init(timeIntervalSinceNow: oneYearAgoInSeconds)
        var retArr: [MonthDate] = []
        
        for i in 0...730 {
            let constant = oneYearAgoInSeconds + (Double(i) * secondsInDay * 1.0)
            let date = Date.init(timeIntervalSinceNow: constant)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M"
            let monthString = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "d"
            let dateString = dateFormatter.string(from: date)
            retArr.append(MonthDate(monthString, dateString))
        }
        
        return retArr
    }
    
    static func generateDayFacts(_ index: Int) {
        let monthDateArr = generateMonthDateObjects()
        getFactForDayFact(monthDateArr[index], completion: {df in
            facts.append(df)
            if index == 729 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "launchApp"), object: nil)
                return
            }
            generateDayFacts(index + 1)
        })
    }
    
    static func getFactForDayFact(_ day: MonthDate, _ indexOffset: Int = 10, completion: @escaping (DayFacts) -> Void) {
        let request = AF.request("https://byabbe.se/on-this-day/\(day.month)/\(day.date)/events.json")
        request.responseJSON(completionHandler: {(data) in
            if let json = data.value as? [String:Any] {
                let events = json["events"] as! NSArray
                let displayEvent = events[(events.count - indexOffset)] as! NSDictionary
                let eventYear = (displayEvent["year"] as! NSString) as String
                guard let eventDescription = (displayEvent["description"] as? NSString) else {
                    getFactForDayFact(day, indexOffset + 1) {df in
                        completion(df)
                    }
                    return
                }
                completion(DayFacts(eventYear, (eventDescription as String)))
            }
        })
    }
}

struct MonthDate {
    var month: String
    var date: String
    init(_ month: String, _ date: String) {
        self.month = month
        self.date = date
    }
}

struct DayFacts {
    var year: String
    var event: String
    init(_ year: String, _ event: String) {
        self.year = year
        self.event = event
    }
}
