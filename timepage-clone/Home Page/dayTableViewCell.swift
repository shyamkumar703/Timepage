//
//  dayTableViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/14/21.
//

import UIKit
import EventKit

class dayTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var event1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var event2: UILabel!
    @IBOutlet weak var currentDayView: UIView!
    @IBOutlet weak var moreLabel: UILabel!
    
    var numEvents = 0
    var displayedEvents = 0
    var stopAnimation: Bool = false
    
    var cellStruct: HomeCalendarCell? = nil {
        didSet {
            numEvents = cellStruct?.events.count ?? 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.textColor = .white
        dateLabel.textColor = .white
        
        dot1.layer.cornerRadius = 2.5
        dot2.layer.cornerRadius = 2.5
        
        currentDayView.layer.cornerRadius = 2
        
        
        // Initialization code
    }
    
    func setupCell() {
        moreLabel.alpha = 0
        stopAnimation = false
        if numEvents == 0 {
            clearCell()
            return
        }

        event1.text = cellStruct?.events[0].title
        time1.text = dayTableViewCell.makeTimeStringForEvent((cellStruct?.events[0])!)
        
        if numEvents == 1 {
            oneEvent()
            return
        }
        
        event2.text = cellStruct?.events[1].title
        time2.text = dayTableViewCell.makeTimeStringForEvent((cellStruct?.events[1])!)
        
        repopulateCell()

        
        if numEvents > 2 {
            moreLabel.text = "+ \(numEvents - 2) More"
            moreLabel.alpha = 1
        }
    }
    
    override func prepareForReuse() {
        stopAnimation = true
        nukeAnimations()
        clearCell()
    }
    
    func oneEvent() {
        event2.alpha = 0
        time2.alpha = 0
        dot2.alpha = 0
        
        event1.alpha = 1
        time1.alpha = 1
        dot1.alpha = 1
    }
    
    func clearCell() {
        event2.alpha = 0
        time2.alpha = 0
        event1.alpha = 0
        time1.alpha = 0
        dot1.alpha = 0
        dot2.alpha = 0
    }
    
    func repopulateCell() {
        event2.alpha = 1
        time2.alpha = 1
        event1.alpha = 1
        time1.alpha = 1
        dot1.alpha = 1
        dot2.alpha = 1
    }
    
    static func makeTimeStringForEvent(_ currEvent1: EKEvent) -> String {
        if currEvent1.isAllDay {
            return "ALL DAY"
        } else {
            let startDate1 = currEvent1.startDate
            let endDate1 = currEvent1.endDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            let startTime1 = dateFormatter.string(from: startDate1!)
            let endTime1 = dateFormatter.string(from: endDate1!)
            
            return startTime1 + " - " + endTime1
        }
    }
    
    func nukeAnimations() {
        self.subviews.forEach({$0.layer.removeAllAnimations()})
        self.layer.removeAllAnimations()
        self.layoutIfNeeded()
    }
    
    func animateEvents(_ startIndex: Int) {
        if stopAnimation {
            return
        }
        
        if numEvents <= 2 {
            return
        }
        
        if startIndex >= numEvents {
            animateEvents(0)
            return
        }
        
        if startIndex == numEvents - 1 {
            //TODO
            UIView.animate(withDuration: 0.3, delay: 4, options: .curveEaseInOut, animations: {
                self.clearCell()
            }, completion: {fin in
                if fin {
                    if startIndex > self.numEvents - 1 {
//                        UIView.animate(withDuration: 0.1, animations: {
//                            self.clearCell()
//                            self.setupCell()
//                        })
                        self.clearCell()
                        self.setupCell()
                        return
                    }
                    self.event1.text = self.cellStruct?.events[startIndex].title
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        self.oneEvent()
                    }, completion: {fin in
                        if fin {
                            self.animateEvents(0)
                            return
                        }
                    })
                }
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 4, options: .curveEaseInOut, animations: {
                self.clearCell()
            }, completion: {fin in
                if fin {
                    if startIndex + 1 > self.numEvents - 1 {
//                        UIView.animate(withDuration: 0.1, animations: {
//                            self.clearCell()
//                            self.setupCell()
//                        })
                        self.clearCell()
                        self.setupCell()
                        return
                    }
                    
                    self.event1.text = self.cellStruct!.events[startIndex].title
                    self.event2.text = self.cellStruct!.events[startIndex + 1].title
                    
                    let currEvent1 = self.cellStruct!.events[startIndex]
                    let currEvent2 = self.cellStruct!.events[startIndex + 1]
                    
                    //EVENT 1 HANDLING
                    if currEvent1.isAllDay {
                        self.time1.text = "ALL DAY"
                    } else {
                        let startDate1 = currEvent1.startDate
                        let endDate1 = currEvent1.endDate
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        
                        let startTime1 = dateFormatter.string(from: startDate1!)
                        let endTime1 = dateFormatter.string(from: endDate1!)
                        
                        self.time1.text = startTime1 + " - " + endTime1
                    }
                    
                    //EVENT 2 HANDLING
                    if currEvent2.isAllDay {
                        self.time2.text = "ALL DAY"
                    } else {
                        let startDate2 = currEvent2.startDate
                        let endDate2 = currEvent2.endDate
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        
                        let startTime2 = dateFormatter.string(from: startDate2!)
                        let endTime2 = dateFormatter.string(from: endDate2!)
                        
                        self.time2.text = startTime2 + " - " + endTime2
                    }
                    
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                        self.repopulateCell()
                    }, completion: {fin in
                        if fin {
                            self.animateEvents(startIndex + 2)
                        }
                    })
                }
            })
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
