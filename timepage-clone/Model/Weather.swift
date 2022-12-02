//
//  Weather.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/16/21.
//

import Foundation
import Alamofire

var globalHourlyDict: [String: [HourlyForecast]] = [:]

var globalSunriseSunsetDict: [String: SunriseSunset] = [:]

class Weather {
    static var forecast: [Forecast] = []
    
    static func fetchWeatherForecast(_ completion: @escaping () -> Void) {
        let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=37.36883444722335&lon=-122.01421521706283&exclude=current,minutely,hourly,alerts&appid=1f9e3e9566eedd283a4f137c0543c422&units=imperial")
        request.responseJSON(completionHandler: {(data) in
            if let json = data.value as? [String:Any] {
                let dailyForecast = json["daily"] as! NSArray
                for day in dailyForecast {
                    if let dat = day as? NSDictionary {
                        let sunrise = Date(timeIntervalSince1970: Double(truncating: dat["sunrise"] as! NSNumber))
                        let sunset = Date(timeIntervalSince1970: Double(truncating: dat["sunset"] as! NSNumber))
                        
                        let ssObject = SunriseSunset(sunrise, sunset)
                        
                        globalSunriseSunsetDict[sunrise.dayMonthDate()!] = ssObject
                        
                        let temp = Int(((dat["temp"] as! NSDictionary)["day"] as! NSNumber) as! Double)
                        let humidity = (dat["humidity"] as! NSNumber) as! Int
                        let description = (((dat["weather"] as! NSArray)[0] as! NSDictionary)["description"] as! NSString) as String
                        let dayForecast = Forecast(temp, humidity, description)
                        forecast.append(dayForecast)
                        print(description)
                    }
                }
                completion()
            } else {
                completion()
            }
        })
    }
    
    static func fetchHourlyWeather(_ completion: @escaping () -> Void) {
        var hourlyDict: [String: [HourlyForecast]] = [:]
        let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=37.36883444722335&lon=-122.01421521706283&exclude=daily,alerts,current,minutely&appid=1f9e3e9566eedd283a4f137c0543c422&units=imperial")
        request.responseJSON(completionHandler: {(data) in
            if let json = data.value as? [String:Any] {
                let forecast = json["hourly"] as! NSArray
                for hour in forecast {
                    if let hr = hour as? NSDictionary {
                        let time = Date(timeIntervalSince1970: Double(truncating: hr["dt"] as! NSNumber))
                        let temp = Int(truncating: hr["temp"] as! NSNumber)
                        let humidity = Int(truncating: hr["humidity"] as! NSNumber)
                        if let weather = (hr["weather"] as? NSArray) {
                            if let w = weather[0] as? NSDictionary {
                                let description = String(w["description"] as! NSString)
                                let hF = HourlyForecast(temp, humidity, description, time.hourAndMinute()!, time)
                                if hourlyDict.keys.contains(hF.dateObject.dayMonthDate()!) {
                                    hourlyDict[hF.dateObject.dayMonthDate()!]?.append(hF)
                                } else {
                                    hourlyDict[hF.dateObject.dayMonthDate()!] = [hF]
                                }
                            }
                        }
                    }
                }
                globalHourlyDict = hourlyDict
                completion()
            } else {
                completion()
            }
        })
    }
}

struct Forecast {
    var temp: Int
    var humidity: Int
    var description: String
    
    init(_ temp: Int, _ humidity: Int, _ description: String) {
        self.temp = temp
        self.humidity = humidity
        self.description = description
    }
    
    func tempString() -> String {
        return " " + String(temp) + "°"
    }
    
    func descriptionString() -> String {
        return "\(humidity)% humidity and \(description) in Sunnyvale"
    }
}

struct HourlyForecast {
    var temp: Int
    var humidity: Int
    var description: String
    var time: String
    var dateObject: Date
    var sunriseDate: Date? = nil
    var sunsetDate: Date? = nil
    
    init(_ temp: Int, _ humidity: Int, _ description: String, _ time: String, _ dateObject: Date) {
        self.temp = temp
        self.humidity = humidity
        self.description = description
        self.time = time
        self.dateObject = dateObject
    }
    
    func tempString() -> String {
        return " " + String(temp) + "°"
    }
    
    func descriptionString() -> String {
        return "\(humidity)% humidity and \(description) in Sunnyvale"
    }

}

struct SunriseSunset {
    var sunrise: Date
    var sunset: Date
    
    init(_ sunrise: Date, _ sunset: Date) {
        self.sunset = sunset
        self.sunrise = sunrise
    }
}
