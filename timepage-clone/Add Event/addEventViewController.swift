//
//  addEventViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/17/21.
//

import UIKit

class addEventViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "datePicker", for: indexPath) as? datePickerCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var addEventView: UIView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    override var prefersStatusBarHidden: Bool
    {
         return true
    }
    
    var collectionScrollView: UIScrollView? = nil
    var lastContentOffset: CGPoint = CGPoint(x: 0, y: 0)
    
    var tableViewVisible = false
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var datePickerCollectionView: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var endDayLabel: UILabel!
    
    @IBOutlet weak var setTime: UILabel!
    @IBOutlet weak var allDay: UILabel!
    @IBOutlet weak var multiDay: UILabel!
    @IBOutlet weak var dayStack: UIStackView!
    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var specialTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backTableView: UIView!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewToTop: NSLayoutConstraint! // 26 to 20

    
    
    
    var startTimeSelected = false {
        didSet {
            if startTimeSelected {
                UIView.animate(withDuration: 0.3, animations: {
                    self.startTime.textColor = .white
                    self.endTime.textColor = Colors.lightWhite
                    self.endDayLabel.textColor = Colors.lightWhite
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.startTime.textColor = Colors.lightWhite
                    self.endTime.textColor = .white
                    self.endDayLabel.textColor = .white
                })
            }
        }
    }
    
    var setTimeSelected = true
    
    var startDate: Date = Date().nearestHour()
    var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date().nearestHour())!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
        self.hero.modalAnimationType = .zoomOut
        view.backgroundColor = Colors.darkBlue
        eventTextView.delegate = self
        
        addEventView.backgroundColor = Colors.lighterBlue
        addEventView.layer.cornerRadius = 20
        
        datePickerCollectionView.backgroundColor = Colors.lighterBlue
        datePickerCollectionView.delegate = self
        datePickerCollectionView.dataSource = self
        
        setupToolbar()
        
        datePickerCollectionView.scrollToItem(at: IndexPath(row: 5000, section: 0), at: .left, animated: false)
        
        addGestureRecognizers()
        startTimeSelected = true
        
        loadViewForStartDate()
        endDayLabel.alpha = 0
        
        addEventView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        specialTableView.delegate = self
        specialTableView.dataSource = self
        
//        specialTableView.alpha = 0
//        navigationBar.alpha = 0
//        backTableView.alpha = 0
        backViewHeight.constant = 0
        view.layoutIfNeeded()
        
//        eventTextView.becomeFirstResponder()
        
        locationButton.alpha = 0
        
        addGestureRecognizers()

        // Do any additional setup after loading the view.
    }
    
    func toggleTableView() {
        if !tableViewVisible {
            UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseInOut, animations: {
                self.backViewHeight.constant = 385
                self.view.layoutIfNeeded()
            }, completion: nil)
            tableViewVisible = true
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.backViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.tableViewVisible = false
                self.eventTextView.becomeFirstResponder()
            })
        }
    }
    
    func setScrollView() {
        for view in self.view.subviews {
            if view is UIScrollView {
                collectionScrollView = view as? UIScrollView
                break
            }
        }
    }
    
    func loadViewForStartDate() {
        startTime.text = startDate.hourAndMinute()
        endTime.text = endDate.hourAndMinute()
        dayLabel.text = startDate.fullDayOfWeek()
        dateLabel.text = startDate.monthDateAndYear()
        if endDate.dateDay() != startDate.dateDay() {
            endDayLabel.text = endDate.dateDay()
            endDayLabel.alpha = 1
        } else {
            endDayLabel.alpha = 0
        }
        
    }
    
    func loadViewForEndDate() {
        endTime.text = endDate.hourAndMinute()
        if endDate.dateDay() != startDate.dateDay() {
            endDayLabel.text = endDate.dateDay()
            endDayLabel.alpha = 1
        } else {
            endDayLabel.alpha = 0
        }
    }
    
    func addGestureRecognizers() {
        var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectStart))
        startTime.isUserInteractionEnabled = true
        startTime.addGestureRecognizer(tapRecognizer)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectEnd))
        endTime.isUserInteractionEnabled = true
        endTime.addGestureRecognizer(tapRecognizer)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAllDay))
        allDay.isUserInteractionEnabled = true
        allDay.addGestureRecognizer(tapRecognizer)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectSetTime))
        setTime.isUserInteractionEnabled = true
        setTime.addGestureRecognizer(tapRecognizer)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectDay))
        dayLabel.isUserInteractionEnabled = true
        dayLabel.addGestureRecognizer(tapRecognizer)
        
    }
    
    @objc func selectDay() {
        performSegue(withIdentifier: "showCalendar", sender: self)
    }
    
    @objc func selectStart() {
        if startTimeSelected == false {
            startTimeSelected = true
        }
    }
    
    @objc func selectEnd() {
        if startTimeSelected {
            startTimeSelected = false
        }
    }
    
    @objc func selectSetTime() {
        if !setTimeSelected {
            allDay.textColor = Colors.lightWhite
            setTime.textColor = .white
            setTimeSelected = true
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.dayStack.transform = CGAffineTransform(scaleX: 1/1.2, y: 1/1.2).translatedBy(x: 0, y: -30)
                self.datePickerCollectionView.alpha = 1
                self.timeStack.alpha = 1
            }, completion: {_ in
//                self.datePickerCollectionView.alpha = 1
//                self.timeStack.alpha = 1
            })
        }
    }
    
    @objc func selectAllDay() {
        if setTimeSelected {
            self.datePickerCollectionView.alpha = 0
            self.timeStack.alpha = 0
            allDay.textColor = .white
            setTime.textColor = Colors.lightWhite
            setTimeSelected = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.dayStack.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).translatedBy(x: 0, y: 30)
            }, completion: nil)
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionScrollView != nil {
            if indexPath.row % 4 == 0 {
                generator.impactOccurred()
                if (collectionScrollView?.contentOffset.x)! > lastContentOffset.x {
                    if startTimeSelected {
                        startDate = startDate.add15Minutes()
                        endDate = endDate.add15Minutes()
                        loadViewForStartDate()
                    } else {
                        endDate = endDate.add15Minutes()
                        loadViewForEndDate()
                    }
                } else if (collectionScrollView?.contentOffset.x)! < lastContentOffset.x {
                    if startTimeSelected {
                        startDate = startDate.subtract15Minutes()
                        endDate = endDate.subtract15Minutes()
                        loadViewForStartDate()
                    } else {
                        endDate = endDate.subtract15Minutes()
                        loadViewForEndDate()
                    }
                }
            }
        }
    }
    
    func setupToolbar() {
        let bar = UIToolbar()
        bar.barTintColor = .black
        
        let ximage = UIImage(systemName: "xmark")?.withTintColor(.white)
        let newBar = UIBarButtonItem(image: ximage, style: .plain, target: self, action: #selector(closeTapped))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let locationImage = UIImage(systemName: "mappin")?.withTintColor(.white)
        let location = UIBarButtonItem(image: locationImage, style: .plain, target: self, action: #selector(locationTapped))
        
        let checkImage = UIImage(systemName: "checkmark")?.withTintColor(.white)
        let done = UIBarButtonItem(image: checkImage, style: .plain, target: self, action: #selector(doneTapped))
        
        newBar.tintColor = .white
        done.tintColor = .white
        location.tintColor = .white
        bar.items = [newBar, space, done]
        bar.sizeToFit()
        eventTextView.inputAccessoryView = bar
    }
    
    @objc func locationTapped() {
        eventTextView.resignFirstResponder()
        toggleTableView()
    }
    
    @objc func closeTapped() {
        self.eventTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func doneTapped() {
        self.eventTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)

        DispatchQueue.main.async() {
            if self.setTimeSelected {
                Event(self.eventTextView.text, self.startDate, self.endDate).addToCalendar()
            } else {
                Event(self.eventTextView.text, self.startDate, self.endDate, true).addToCalendar()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.addEventView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addEventView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {_ in
//            self.specialTableView.alpha = 1
//            self.navigationBar.alpha = 1
//            self.backTableView.alpha = 1
        })
        self.eventTextView.becomeFirstResponder()
        setScrollView()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        eventTextView.text = nil
        eventTextView.textColor = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? selectDayViewController {
            destVC.selectedDate = startDate
            destVC.parentView = self
        }
    }
    
    @IBAction func closeTableView(_ sender: Any) {
        toggleTableView()
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

extension addEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "specialCell") as? specialTableViewCell {
            cell.locationTitle.text = Array(Cal.pastLocations)[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    
}
