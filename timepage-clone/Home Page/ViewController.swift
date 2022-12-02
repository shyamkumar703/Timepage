//
//  ViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/14/21.
//

import UIKit
import Hero
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dayArr = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    lazy var dateSrcArr: [HomeCalendarCell] = {
        Cal.generateDateObjectArray()
    }()
    
    lazy var currentMonthYear: String = {
        dateSrcArr[365].monthAndYear
    }()
    
    lazy var lastDisplayedMonthYear: String = {
        currentMonthYear
    }()
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var selectedHomeCell: HomeCalendarCell? = nil
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateSrcArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? dayTableViewCell {
            if indexPath.row % 2 == 0 {
                cell.backView.backgroundColor = Colors.darkBlue
            } else {
                cell.backView.backgroundColor = Colors.lightBlue
            }
            
            var currCell = dateSrcArr[indexPath.row]
            currCell.id = String(indexPath.row)
            cell.backView.hero.id = String(indexPath.row)
            cell.backView.hero.isEnabled = true
            
            if Cal.compareDate(date1: Date(), date2: currCell.date) {
                cell.dayLabel.textColor = Colors.royalPurple
                cell.dateLabel.textColor = Colors.royalPurple
                cell.currentDayView.alpha = 1
            } else {
                cell.dayLabel.textColor = .white
                cell.dateLabel.textColor = .white
                cell.currentDayView.alpha = 0
                cell.currentDayView.backgroundColor = .white
            }
            cell.dayLabel.text = currCell.dayOfWeek
            cell.dateLabel.text = currCell.dateNumber
            
            cell.cellStruct = currCell
            cell.setupCell()
            
            return cell
        }
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPath = self.tableView.indexPathsForVisibleRows![0]
        let indexOfThirdVisible = indexPath.row + 2
        let cell = tableView.cellForRow(at: IndexPath(row: indexOfThirdVisible, section: indexPath.section)) as! dayTableViewCell
        
        if cell.cellStruct!.monthAndYear != lastDisplayedMonthYear {
            self.monthLabel.text = cell.cellStruct!.monthAndYear
            self.lastDisplayedMonthYear = cell.cellStruct!.monthAndYear
            self.monthLabel.textColor = .white
        } else if cell.cellStruct!.monthAndYear == currentMonthYear {
            self.monthLabel.textColor = Colors.royalPurple
            self.lastDisplayedMonthYear = cell.cellStruct!.monthAndYear
        }
        
        let indexOfFirstVisible = self.tableView.indexPathsForVisibleRows!.first!.row
        if indexOfFirstVisible > 370 {
            self.upButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.upButton.alpha = 1
            }, completion: nil)
        } else if indexOfFirstVisible < 360{
            self.upButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.upButton.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.upButton.alpha = 0
            }, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHomeCell = (tableView.cellForRow(at: indexPath) as! dayTableViewCell).cellStruct
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        OnThisDay.getFactForDayFact(selectedHomeCell!.monthDate, completion: {df in
            self.selectedHomeCell?.dayFacts = df
            self.performSegue(withIdentifier: "showDay", sender: self)
        })
    }
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool
    {
         return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        monthLabel.rotate(degrees: 90, clockwise: false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.scrollToRow(at: IndexPath(row: 365, section: 0), at: .middle, animated: false)
//        self.view.backgroundColor = Colors.darkBlue
        monthLabel.textColor = Colors.royalPurple
        
        upButton.layer.cornerRadius = 25
        upButton.backgroundColor = .white
        upButton.tintColor = Colors.royalPurple
        upButton.alpha = 0
        
        plusButton.layer.cornerRadius = 25
        plusButton.backgroundColor = Colors.lighterBlue
        plusButton.tintColor = .white
        
        registerLocal()
        scheduleLocal()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "eventAdded"), object: nil)
    }
    
    @objc func reloadData() {
        dateSrcArr = Cal.generateDateObjectArray()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Cal.requestAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if openDailyBrief {
            tableView.selectRow(at: IndexPath(row: 365, section: 0), animated: false, scrollPosition: .none)
        }
    }
    
    func clearView(_ alpha: CGFloat) {
        monthLabel.alpha = alpha
        for cell in tableView.visibleCells {
            if let currCell = cell as? dayTableViewCell {
                currCell.stopAnimation = true
                currCell.currentDayView.alpha = 0
                currCell.event2.alpha = alpha
                currCell.time2.alpha = alpha
                currCell.event1.alpha = alpha
                currCell.time1.alpha = alpha
                currCell.dateLabel.alpha = alpha
                currCell.dayLabel.alpha = alpha
                currCell.dot2.alpha = alpha
                currCell.dot1.alpha = alpha
                currCell.backView.backgroundColor = Colors.darkBlue
                tableView.separatorStyle = .none
            }
        }
    }
    
    
    @IBAction func toToday(_ sender: Any) {
        tableView.scrollToRow(at: IndexPath(row: 365, section: 0), at: .middle, animated: true)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @IBAction func createEvent(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
//        UIView.animate(withDuration: 0.1, animations: {
//            self.plusButton.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
//        }, completion: {_ in
//            UIView.animate(withDuration: 0.1, animations: {
//                self.plusButton.transform = CGAffineTransform(scaleX: 1/1.35, y: 1/1.35)
//            }, completion: {_ in
//                self.performSegue(withIdentifier: "addEvent", sender: self)
//            })
//        })
        self.performSegue(withIdentifier: "addEvent", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? dayDetailsViewController {
            destVC.dayEvents = selectedHomeCell
        }
    }
    
    //MARK:- NOTIFICATIONS
    func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("")
            } else {
                print("")
            }
        }
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Daily Brief"
        content.body = "Your daily brief is ready"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.removeAllPendingNotificationRequests()
        center.add(request)
    }
    

}

extension UILabel {
    func rotate(degrees: Int , clockwise: Bool)
    {
        let x  = 180 / degrees
        if (clockwise)
        {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / CGFloat(x))
        }
        else
        {
            self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / CGFloat(x))
        }
    }
}

