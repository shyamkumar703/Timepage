//
//  Event.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/17/21.
//

import Foundation
import EventKit

struct Event {
    var title: String
    var dateStart: Date
    var dateEnd: Date
    var allDay: Bool
    
    init(_ title: String, _ dateStart: Date, _ dateEnd: Date, _ allDay: Bool = false) {
        self.title = title
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.allDay = allDay
    }
    
    func addToCalendar() {
        let newEvent = EKEvent(eventStore: store)
        newEvent.calendar = store.defaultCalendarForNewEvents
        newEvent.title = title
        if allDay {
            newEvent.isAllDay = true
            newEvent.startDate = dateStart
            newEvent.endDate = dateEnd
        } else {
            newEvent.startDate = dateStart
            newEvent.endDate = dateEnd
        }
        do {
            try store.save(newEvent, span: .thisEvent)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "eventAdded"), object: nil)
        } catch {
            return
        }
    }
}
