//
//  eventDetailsViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/16/21.
//

import UIKit
import MapKit
import EventKit

class eventDetailsViewController: UIViewController {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var calendarName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var timeToLeave: UILabel!
    @IBOutlet weak var remindersToStack: NSLayoutConstraint!
    @IBOutlet weak var rsvp: UILabel!
    @IBOutlet weak var rsvpStatus: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var fullNotes: UILabel!
    
    override var prefersStatusBarHidden: Bool
    {
         return true
    }
    
    var currEvent: EKEvent? = nil
    var viewID: IDValues? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarName.layer.cornerRadius = 5
        calendarName.textColor = .black
        calendarName.layer.masksToBounds = true
        
        mapView.layer.cornerRadius = 75
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.white.cgColor
        
        self.isHeroEnabled = true
//        self.hero.modalAnimationType = .zoomOut
        
        address.adjustsFontSizeToFitWidth = true
        
        view.backgroundColor = Colors.darkBlue
        
        view.isHeroEnabled = true
        eventTitle.isHeroEnabled = true
        calendarName.isHeroEnabled = true
        
        if viewID != nil {
            view.hero.id = viewID!.backgroundID
            eventTitle.hero.id = viewID!.titleID
            calendarName.hero.id = viewID!.accentID
        }
        
        
//        noTimeToLeave()
//
//        setMapLocation(37.36883444722335, -122.01421521706283)
//
//        address.text = "462 Liquidambar Way Sunnyvale".uppercased()
        setupView()
        setupGesture()

        

        // Do any additional setup after loading the view.
    }
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        self.address.addGestureRecognizer(tap)
        self.address.isUserInteractionEnabled = true
    }
    
    @objc func locationTapped() {
        if let text = address.text {
            if let url = URL(string: text) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.open(URL(string: "http://maps.apple.com/?address=" + text.replacingOccurrences(of: " ", with: "%20"))!)
            }
        }
    }
    
    func setupView() {
        noTimeToLeave()
        calendarName.text = currEvent?.calendar.title.uppercased()
        
        eventTitle.text = currEvent?.title
        eventTitle.adjustsFontSizeToFitWidth = true
        
        eventTime.text = dayTableViewCell.makeTimeStringForEvent(currEvent!)
        if let loc = currEvent?.structuredLocation?.geoLocation {
            setMapLocation(loc.coordinate.latitude, loc.coordinate.longitude)
            address.text = currEvent?.location
        } else {
            if currEvent?.location != nil {
                setMapLocation(37.36883444722335, -122.01421521706283)
                address.text = currEvent?.location
            } else {
                noMap()
            }
        }
        
        if let eventNotes = currEvent?.notes {
            fullNotes.text = eventNotes
        } else {
            noNotes()
        }
        
        rsvpStatus.text = "YES"
    }
    
    func setMapLocation(_ lat: Double, _ long: Double) {
        let initialLocation = CLLocation(latitude: lat, longitude: long)
        mapView.centerToLocation(initialLocation)
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(myAnnotation)
    }
    
    func noMap() {
        mapView.alpha = 0
        address.alpha = 0
        timeToLeave.alpha = 0
        remindersToStack.constant = 35
    }
    
    func noNotes() {
        notes.alpha = 0
        fullNotes.alpha = 0
    }
    
    func noTimeToLeave() {
        remindersToStack.constant = remindersToStack.constant - 45
        timeToLeave.alpha = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
