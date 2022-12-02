//
//  EventTableViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/22/21.
//

import UIKit
import EventKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventAccent: UIView!
    
    var event: EKEvent? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        eventTitle.text = event?.title
        eventTime.text = dayTableViewCell.makeTimeStringForEvent(event!)
        eventAccent.layer.cornerRadius = 2.5
        
        let randomInt = Int.random(in: 0...2)
//        let colorArr = [Colors.yellow, Colors.lighterBlue, Colors.green]
        let colorArr = [UIColor(red:0.88, green:0.67, blue:0.12, alpha:1.0), UIColor(red:0.13, green:0.62, blue:0.98, alpha:1.0), UIColor(red:1.00, green:0.44, blue:0.44, alpha:1.0)]
        
        eventAccent.backgroundColor = colorArr[randomInt]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
