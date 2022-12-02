//
//  dayDetailsViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/14/21.
//

import UIKit
import Hero
import EventKit

class dayDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherViewHeight: NSLayoutConstraint!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDetailsToTop: NSLayoutConstraint!
    @IBOutlet weak var onThisDayYear: UILabel!
    @IBOutlet weak var onThisDayDescription: UILabel!
    @IBOutlet weak var onThisDayView: UIView!
    
    var holdGesture: UILongPressGestureRecognizer? = nil
    
    var numCells = 0
    var numTodo = 0
    
    var selectedEvent: EKEvent? = nil
    
    var selectedId: IDValues? = nil
    
    var dayEvents: HomeCalendarCell? = nil {
        didSet {
            numCells = (dayEvents?.events.count)!
        }
    }
    
    var cellToDelete: Int = 0
    
    var weatherController: weatherDetailsViewController? = nil
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return (dayEvents?.events.count)!
        } else {
            return numTodo
        }
    }
    
    override var prefersStatusBarHidden: Bool
    {
         return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            if let cell = classCollectionView.dequeueReusableCell(withReuseIdentifier: "classView", for: indexPath) as? classCollectionViewCell {
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                cell.backgroundColor = Colors.lighterBlue
                
                let currEvent = dayEvents?.events[indexPath.row]
                cell.className.text = currEvent?.title
                cell.time.text = dayTableViewCell.makeTimeStringForEvent(currEvent!)
                
                cell.idValues = IDValues(String(indexPath.row), String(indexPath.row) + "title", String(indexPath.row) + "accent", currEvent!)
                cell.hero.id = String(indexPath.row)
                cell.className.hero.id = String(indexPath.row) + "title"
                cell.colorView.hero.id = String(indexPath.row) + "accent"
                
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress))
                cell.addGestureRecognizer(longPress)
                cell.tag = indexPath.row
                
                
                return cell
            }
            return UICollectionViewCell()
        } else {
            return UICollectionViewCell()
        }
    }
    
    @objc func cellLongPress(_ sender: UILongPressGestureRecognizer) {
        if let cell = sender.view as? classCollectionViewCell {
            let ac = UIAlertController()
            ac.addAction(UIAlertAction(title: "Delete Event", style: .destructive, handler: deleteEvent))
            cellToDelete = cell.tag
            present(ac, animated: true, completion: nil)
        }
    }
    
    func deleteEvent(_ alert: UIAlertAction) {
        
        try? store.remove((classCollectionView.cellForItem(at: IndexPath(row: cellToDelete, section: 0)) as! classCollectionViewCell).idValues!.event , span: .thisEvent, commit: true)
        
        NotificationCenter.default.post(name: NSNotification.Name("eventAdded"), object: nil)
        
        classCollectionView.deleteItems(at: [IndexPath(row: cellToDelete, section: 0)])
        dayEvents?.events.remove(at: cellToDelete)
        classCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEvent = dayEvents?.events[indexPath.row]
        selectedId = (collectionView.cellForItem(at: indexPath) as! classCollectionViewCell).idValues
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? eventDetailsViewController {
            destVC.currEvent = selectedEvent
            destVC.viewID = selectedId
        }
        
        if let destVC = segue.destination as? weatherDetailsViewController {
            destVC.recognizer = holdGesture!
            destVC.dayEvents = dayEvents
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if holdGesture != nil {
            self.view.removeGestureRecognizer(holdGesture!)
        }
    }
    
    
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var classCollectionHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        
        view.backgroundColor = Colors.darkBlue
        self.hero.modalAnimationType = .zoomOut
        
        classCollectionHeightConstraint.constant = CGFloat(numCells * 63)
        
        dayLabel.text = dayEvents?.date.fullDayOfWeek()
        dateLabel.text = dayEvents?.date.monthDateAndYear()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToRightSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToLeftSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        if numCells == 0 {
            scheduleLabel.alpha = 0
        }
        
        setupWeatherView()
        setupOnThisDay()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupWeatherView()
    }
    
    func setupOnThisDay() {
        onThisDayView.layer.cornerRadius = 20
        onThisDayView.backgroundColor = Colors.lighterBlue
        onThisDayYear.text = dayEvents?.dayFacts?.year
        onThisDayDescription.text = dayEvents?.dayFacts?.event
        onThisDayDescription.adjustsFontSizeToFitWidth = true
        onThisDayYear.adjustsFontSizeToFitWidth = true
    }
    
    func setupWeatherView() {
        if let weather = dayEvents?.weather {
            weatherView.layer.cornerRadius = 20
            weatherView.backgroundColor = Colors.lighterBlue
            temperature.text = weather.tempString()
            weatherDescription.text = weather.descriptionString()
            
            var holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHoldWeather))
            if globalHourlyDict.keys.contains((dayEvents?.date.dayMonthDate())!) {
                holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHoldWeather))
                weatherView.addGestureRecognizer(holdGesture)
            }
            holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(longHoldWeather))
            weatherView.addGestureRecognizer(holdGesture)
            self.holdGesture = holdGesture
            
            weatherView.isHeroEnabled = true
            weatherView.hero.id = "backWeather"
            
            weatherImage.hero.id = "weatherImage"
            
            temperature.hero.id = "temperature"
            weatherDescription.hero.id = "description"
            
        } else {
            weatherImage.alpha = 0
            temperature.alpha = 0
            weatherDescription.text = "No forecast available."
            weatherViewHeight.constant = 54
            weatherDetailsToTop.constant = 9
            weatherView.layer.cornerRadius = 10
            weatherView.backgroundColor = Colors.lighterBlue
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func longHoldWeather(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            performSegue(withIdentifier: "weatherDetails", sender: self)
        }
    }
    
    @objc func respondToRightSwipeGesture() {
        switchDay()
    }
    
    @objc func respondToLeftSwipeGesture() {
        switchDay()
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func switchDay() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.dayLabel.alpha = 0
            self.dateLabel.alpha = 0
            self.scheduleLabel.alpha = 0
            self.classCollectionView.alpha = 0
        }, completion: {fin in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.dayLabel.alpha = 1
                self.dateLabel.alpha = 1
                self.scheduleLabel.alpha = 1
                self.classCollectionView.alpha = 1
            }, completion: nil)
        })
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct IDValues {
    var backgroundID: String = ""
    var titleID: String = ""
    var accentID: String = ""
    var event: EKEvent
    
    init(_ backgroundID: String, _ titleID: String, _ accentID: String, _ event: EKEvent) {
        self.backgroundID = backgroundID
        self.titleID = titleID
        self.accentID = accentID
        self.event = event
    }
}
