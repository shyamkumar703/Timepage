//
//  firstCalendarViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/15/21.
//

import UIKit
import EventKit

class firstCalendarViewController: UIViewController {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var dayLabel: UILabel!
    
    var monthDates: [Date] = []
    
    var numRows = 0
    var selectedDate: Date? = nil
    var dateEvents: [EKEvent] = []
    var dayTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayLabel.text = dayTitle
        
//        collectionView.delegate = self
//        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monthLabel.text = dateArr[dateIndex].month()
        yearLabel.text = dateArr[dateIndex].year()
        monthDates = dateArr[dateIndex].getAllDays()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        eventTableView.delegate = self
        eventTableView.dataSource = self

        if dateArr[dateIndex].monthAndYear() == Date().monthAndYear()  {
            monthLabel.textColor = Colors.royalPurple
            yearLabel.textColor = Colors.royalPurple
        } else {
            monthLabel.textColor = .white
            yearLabel.textColor = .white
        }
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

extension firstCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if monthDates.count == 0 {
            self.collectionView.reloadData()
            return 0
        } else {
            return monthDates.count / 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekView", for: indexPath) as? weekViewCollectionViewCell {
            let startIndex = indexPath.row * 7
            let endIndex = ((indexPath.row + 1) * 7) - 1
            let cellDates = Array(monthDates[startIndex...endIndex])
            cell.dates = cellDates
            cell.originalDate = dateArr[dateIndex]
            cell.parentView = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

extension firstCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numRows >= 6 {
            return 6
        } else {
            return numRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = eventTableView.dequeueReusableCell(withIdentifier: "event") as? EventTableViewCell {
            cell.event = dateEvents[indexPath.row]
            cell.setup()
            return cell
        }
        return UITableViewCell()
    }
    
    
}
