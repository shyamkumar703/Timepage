//
//  selectDayViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/19/21.
//

import UIKit

class selectDayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var monthDates: [Date] = []
    
    var weeks = 6
    
    var selectedDate: Date? = nil {
        didSet {
            monthDates = selectedDate!.getAllDays()
            weeks = monthDates.count / 7
            setupDate = selectedDate
        }
    }
    
    var setupDate: Date? = nil
    
    var parentView: addEventViewController? = nil
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayStack: UIStackView!
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "week", for: indexPath) as? weekCollectionViewCell {
            let startIndex = indexPath.row * 7
            let endIndex = ((indexPath.row + 1) * 7) - 1
            let cellDates = Array(monthDates[startIndex...endIndex])
            cell.initializeView(cellDates, Date().month()!, selectedDate!, self, setupDate!)
            
//            cell.one.textColor = Colors.lightWhite
            return cell
        }
        return UICollectionViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.darkBlue
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        
        monthLabel.text = selectedDate!.month()?.uppercased()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        monthLabel.text = setupDate?.month()?.uppercased()
        monthDates = (setupDate?.getAllDays())!
        weeks = monthDates.count / 7
        monthCollectionView.reloadData()
    }
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    override func viewWillDisappear(_ animated: Bool) {
        parentView!.startDate = (selectedDate?.nearestHour())!
        parentView!.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: selectedDate!.nearestHour())!
        parentView?.loadViewForStartDate()
    }
    
    @IBAction func forwardPressed(_ sender: Any) {
        moveForward()
    }
    
    @IBAction func backwardPressed(_ sender: Any) {
        moveBackwards()
    }
    
    @objc func moveForward() {
        UIView.animate(withDuration: 0.3, animations: {
            self.monthLabel.alpha = 0
            self.monthCollectionView.alpha = 0
            self.dayStack.alpha = 0
        }, completion: {_ in
            self.setupDate = Calendar.current.date(byAdding: .month, value: 1, to: self.setupDate!)
            self.setupView()
            UIView.animate(withDuration: 0.3, animations: {
                self.monthLabel.alpha = 1
                self.monthCollectionView.alpha = 1
                self.dayStack.alpha = 1
            }, completion: nil)
        })
    }
    
    @objc func moveBackwards() {
        UIView.animate(withDuration: 0.3, animations: {
            self.monthLabel.alpha = 0
            self.monthCollectionView.alpha = 0
            self.dayStack.alpha = 0
        }, completion: {_ in
            self.setupDate = Calendar.current.date(byAdding: .month, value: -1, to: self.setupDate!)
            self.setupView()
            UIView.animate(withDuration: 0.3, animations: {
                self.monthLabel.alpha = 1
                self.monthCollectionView.alpha = 1
                self.dayStack.alpha = 1
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
