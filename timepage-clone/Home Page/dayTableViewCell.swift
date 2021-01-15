//
//  dayTableViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/14/21.
//

import UIKit

class dayTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var dot3: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var event1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var event2: UILabel!
    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var event3: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dot1.layer.cornerRadius = 2
        dot2.layer.cornerRadius = 2
        dot3.layer.cornerRadius = 2
        dot2.backgroundColor = .green
        dayLabel.textColor = .white
        dateLabel.textColor = .white
        
        let number = Int.random(in: 0..<3)
        switch number {
        case 0:
            time2.alpha = 0
            dot2.alpha = 0
            event2.alpha = 0
            
            time3.alpha = 0
            dot3.alpha = 0
            event3.alpha = 0
            
            moreLabel.alpha = 0
            
        case 1:
            time3.alpha = 0
            dot3.alpha = 0
            event3.alpha = 0
            
            moreLabel.alpha = 0
            
        default:
            print("default")
            
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
