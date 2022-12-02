//
//  dateViewCollectionViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/22/21.
//

import UIKit
import EventKit

class dateViewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    var currDate: Date? = nil
    var originalDate: Date? = nil
    
    var events: [EKEvent] = []
    
    
    func setup() {
        if currDate?.month() != originalDate?.month() {
            dateLabel.textColor = Colors.lightWhite
            return
        }
        
        events = Cal.loadEventsForCell(HomeCalendarCell(currDate!))
        
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 20.5
        
        if events.count != 0 {
            dateLabel.layer.borderWidth = 0.3
            dateLabel.layer.borderColor = Colors.darkBlue.cgColor
        } else {
            return
        }
        
        if events.count >= 4 {
            dateLabel.backgroundColor = Colors.darkBlue.withAlphaComponent(1)
        } else {
            switch events.count {
            case 1:
                dateLabel.backgroundColor = Colors.darkBlue.withAlphaComponent(0.3)
            case 2:
                dateLabel.backgroundColor = Colors.darkBlue.withAlphaComponent(0.5)
            default:
                dateLabel.backgroundColor = Colors.darkBlue.withAlphaComponent(0.7)
            }
//            dateLabel.backgroundColor = Colors.darkBlue.withAlphaComponent(CGFloat(events.count / 4) + 0.15)
        }
    }
    
}
