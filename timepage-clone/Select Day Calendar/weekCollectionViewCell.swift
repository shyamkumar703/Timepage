//
//  weekCollectionViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/19/21.
//

import UIKit

class weekCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var four: UILabel!
    @IBOutlet weak var five: UILabel!
    @IBOutlet weak var six: UILabel!
    @IBOutlet weak var seven: UILabel!
    
    var weekArr: [UILabel] = []
    var parentView: selectDayViewController? = nil
    var dates: [Date] = []
    var currMonth: String = ""
    
    override func awakeFromNib() {
        weekArr = [one, two, three, four, five, six, seven]
    }
    
    override func prepareForReuse() {
        for label in weekArr {
            label.backgroundColor = .clear
            label.layer.borderWidth = 0
            label.textColor = .white
        }
    }
    
    func addTapRecognizer() {
        weekArr = [one, two, three, four, five, six, seven]
        for label in weekArr {
            label.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
            label.addGestureRecognizer(tap)
        }
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        if let label = gesture.view as? UILabel {
            if dates[label.tag].month() == currMonth {
                parentView?.selectedDate = dates[label.tag]
                parentView?.setupDate = dates[label.tag]
                parentView?.monthCollectionView.reloadData()
            }
        }
    }
    
    func initializeView(_ dates: [Date], _ currMonth: String, _ selectedDate: Date, _ parentView: selectDayViewController, _ setupDate: Date) {
        self.parentView = parentView
        self.dates = dates
        self.currMonth = setupDate.month()!
        
        setColor(dates, currMonth, selectedDate, setupDate)
        setupView()
        addTapRecognizer()
        
        
        one.text = dates[0].dateNumber()!
        two.text = dates[1].dateNumber()!
        three.text = dates[2].dateNumber()!
        four.text = dates[3].dateNumber()!
        five.text = dates[4].dateNumber()!
        six.text = dates[5].dateNumber()!
        seven.text = dates[6].dateNumber()
    }
    
    func setupView() {
        one.layer.cornerRadius = 19.5
        one.layer.masksToBounds = true
        
        two.layer.cornerRadius = 19.5
        two.layer.masksToBounds = true
        
        three.layer.cornerRadius = 19.5
        three.layer.masksToBounds = true
        
        four.layer.cornerRadius = 19.5
        four.layer.masksToBounds = true
        
        five.layer.cornerRadius = 19.5
        five.layer.masksToBounds = true
        
        six.layer.cornerRadius = 19.5
        six.layer.masksToBounds = true
        
        seven.layer.cornerRadius = 19.5
        seven.layer.masksToBounds = true
    }
    
    func setColor(_ dates: [Date], _ currMonth: String, _ selectedDate: Date, _ setupDate: Date) {
        for i in 0...6 {
            if dates[i].month() != setupDate.month() {
                switch(i) {
                case 0:
                    one.textColor = Colors.lightWhite
                case 1:
                    two.textColor = Colors.lightWhite
                case 2:
                    three.textColor = Colors.lightWhite
                case 3:
                    four.textColor = Colors.lightWhite
                case 4:
                    five.textColor = Colors.lightWhite
                case 5:
                    six.textColor = Colors.lightWhite
                default:
                    seven.textColor = Colors.lightWhite
                }
            }
            
            if Cal.compareDate(date1: Date(), date2: dates[i]) && dates[i].month() == currMonth {
                switch(i) {
                case 0:
                    one.textColor = Colors.darkBlue
                    one.backgroundColor = .white
                case 1:
                    two.textColor = Colors.darkBlue
                    two.backgroundColor = .white
                case 2:
                    three.textColor = Colors.darkBlue
                    three.backgroundColor = .white
                case 3:
                    four.textColor = Colors.darkBlue
                    four.backgroundColor = .white
                case 4:
                    five.textColor = Colors.darkBlue
                    five.backgroundColor = .white
                case 5:
                    six.textColor = Colors.darkBlue
                    six.backgroundColor = .white
                default:
                    seven.textColor = Colors.darkBlue
                    seven.backgroundColor = .white
                }
            }
            
            if Cal.compareDate(date1: selectedDate, date2: dates[i]) && dates[i].month() == self.currMonth {
                switch(i) {
                case 0:
                    one.layer.borderWidth = 1
                    one.layer.borderColor = UIColor.white.cgColor
                case 1:
                    two.layer.borderWidth = 1
                    two.layer.borderColor = UIColor.white.cgColor
                case 2:
                    three.layer.borderWidth = 1
                    three.layer.borderColor = UIColor.white.cgColor
                case 3:
                    four.layer.borderWidth = 1
                    four.layer.borderColor = UIColor.white.cgColor
                case 4:
                    five.layer.borderWidth = 1
                    five.layer.borderColor = UIColor.white.cgColor
                case 5:
                    six.layer.borderWidth = 1
                    six.layer.borderColor = UIColor.white.cgColor
                default:
                    seven.layer.borderWidth = 1
                    seven.layer.borderColor = UIColor.white.cgColor
                }
            }
        }
    }
    
    
}
