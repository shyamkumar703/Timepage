//
//  weatherDetailsViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/22/21.
//

import UIKit
import Hero
import Charts

class weatherDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var markerView: UIView!
    @IBOutlet weak var markerViewX: NSLayoutConstraint!
    @IBOutlet weak var timeLeadingX: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!

    var recognizer: UILongPressGestureRecognizer? = nil

    override var prefersStatusBarHidden: Bool
    {
         return true
    }

    var yValues: [ChartDataEntry] = []

    var hourlyForecast: [HourlyForecast] = []

    var firstOpen: Bool = true

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
     }

    func setYValues() {
        var newYValues: [ChartDataEntry] = []
        for hour in hourlyForecast {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeString = dateFormatter.string(from: hour.dateObject)
            let time = timeString.split(separator: ":")
            let xValue = Double((Int(time[0])! * 60) + Int(time[1])!)
            let yValue = Double(hour.temp)
            newYValues.append(ChartDataEntry(x: xValue, y: yValue))
        }
        yValues = newYValues
    }

    func setup() {

        setData()

        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.chartDescription.enabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.drawBordersEnabled = false
        lineChartView.legend.form = .none
        lineChartView.marker = nil
        lineChartView.isUserInteractionEnabled = false
    }

    func setData() {
        let set1 = LineChartDataSet(entries: yValues)
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.label = ""
        set1.colors = [.white]

        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)

        lineChartView.data = data
    }

    var dayEvents: HomeCalendarCell? = nil {
        didSet {
            if dayEvents != nil {
                hourlyForecast = globalHourlyDict[dayEvents!.date.dayMonthDate()!]!
                let currSSObject = globalSunriseSunsetDict[dayEvents!.date.dayMonthDate()!]
                sunriseDate = currSSObject?.sunrise
                sunsetDate = currSSObject?.sunset            }
        }
    }

    var sunriseDate: Date? = nil {
        didSet {
            if sunriseDate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let timeString = dateFormatter.string(from: sunriseDate!)
                let time = timeString.split(separator: ":")
                sunriseX = (Int(time[0])! * 60) + Int(time[1])!
            }
        }
    }
    var sunsetDate: Date? = nil {
        didSet {
            if sunsetDate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let timeString = dateFormatter.string(from: sunsetDate!)
                let time = timeString.split(separator: ":")
                sunsetX = (Int(time[0])! * 60) + Int(time[1])!
            }
        }
    }

    var sunriseX = 0
    var sunsetX = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setYValues()

        view.backgroundColor = Colors.lighterBlue

        if recognizer != nil {
            recognizer?.removeTarget(nil, action: nil)
            recognizer?.addTarget(self, action: #selector(handleLongPress))
            self.view.addGestureRecognizer(recognizer!)
            recognizer?.delegate = self
        }

        self.hero.isEnabled = true
        view.hero.id = "backWeather"
        weatherImage.hero.id = "weatherImage"

        temperature.text = dayEvents!.weather?.tempString()
        weatherDescription.text = dayEvents!.weather?.descriptionString()

        setup()

        markerView.backgroundColor = .white

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        updateViewWhenFingerMoves((recognizer?.location(in: view.superview).x)!)
        updateTimeWhenFingerMoves((recognizer?.location(in: view.superview).x)!)
        markerViewX.constant = (recognizer?.location(in: view.superview).x)!
        if recognizer!.location(in: view.superview).x > 51 {
            timeLeadingX.constant = (recognizer!.location(in: view.superview).x) - 47
        }
        view.layoutIfNeeded()
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            self.dismiss(animated: true, completion: nil)
        }
        if gesture.state == .began {
            print("in")
        }
        if gesture.state == .changed {
            updateViewWhenFingerMoves(gesture.location(in: view.superview).x)
            markerViewX.constant = (gesture.location(in: view.superview).x)
            if gesture.location(in: view.superview).x > 51 && gesture.location(in: view.superview).x < UIScreen.main.bounds.width - 51 {
                timeLeadingX.constant = (gesture.location(in: view.superview).x) - 47
            }
            view.layoutIfNeeded()
        }
    }

    func updateViewWhenFingerMoves(_ xValue: CGFloat) {
        updateTimeWhenFingerMoves(xValue)
        let integerX = Int(xValue)
        let possibleX = hourlyForecast.count
        let screenInterval = Int(UIScreen.main.bounds.width) / possibleX
        if integerX % screenInterval == 0 {
            let forecastIndex = integerX / screenInterval
            if forecastIndex >= possibleX {
                return
            }
            let forecastForPos = hourlyForecast[forecastIndex]
            updateViewForForecast(forecastForPos)
        }
    }

    func updateTimeWhenFingerMoves(_ xValue: CGFloat) {
        let integerX = Int(xValue)
        let startTime = yValues.first!.x
        let endTime = yValues.last!.x
        let timePerUnit = (endTime - startTime) / Double(UIScreen.main.bounds.width)

        let currentTime = startTime + (Double(integerX) * timePerUnit)
        createTimeStringFromInt(Int(currentTime))
        updateBackgroundForSunriseSunset(Int(currentTime))
    }

    func createTimeStringFromInt(_ timeInt: Int) {
        var hours = (timeInt / 60)
        let mins = timeInt % 60
        var time = "AM"

        if hours >= 12 {
            time = "PM"
        }

        hours = hours % 12


        if hours == 0 {
            hours = 12
        }

        let hourString = String(hours)
        var minString = String(mins)

        if mins < 10 {
            minString = "0\(mins)"
        }

        timeLabel.text = "\(hourString):\(minString) \(time)"
    }

    func updateBackgroundForSunriseSunset(_ time: Int) {
        let sunriseDiff = time - sunriseX
        let sunsetDiff = sunsetX - time

        //HANDLE SUNRISE CASES
        if sunriseDiff < 0 {
            if firstOpen {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
                })
                firstOpen = false
            } else {
                view.backgroundColor = view.backgroundColor?.withAlphaComponent(0)
            }
            return
        } else if sunriseDiff < 100 {
            if firstOpen {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(CGFloat(sunriseDiff) / 100.0)
                })
                firstOpen = false
            } else {
                view.backgroundColor = view.backgroundColor?.withAlphaComponent(CGFloat(sunriseDiff) / 100.0)
            }
            return
        } else {
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(1)
        }


        //HANDLE SUNSET CASES
        if sunsetDiff < 0 {
            if firstOpen {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
                })
                firstOpen = false
            } else {
                view.backgroundColor = view.backgroundColor?.withAlphaComponent(0)
            }
        } else if sunsetDiff < 100 {
            if firstOpen {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(CGFloat(sunsetDiff) / 100.0)
                })
                firstOpen = false
            } else {
                view.backgroundColor = view.backgroundColor?.withAlphaComponent(CGFloat(sunsetDiff) / 100.0)
            }
        } else {
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(1)
        }
    }

    func updateViewForForecast(_ forecast: HourlyForecast) {
        temperature.text = forecast.tempString()
        weatherDescription.text = forecast.descriptionString()
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
