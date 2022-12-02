//
//  Weather.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/16/21.
//

import Foundation
import Alamofire

class Weather {
    static var forecast: [Forecast] = []
    
    static func fetchWeatherForecast(_ completion: @escaping () -> Void) {
        let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=37.36883444722335&lon=-122.01421521706283&exclude=current,minutely,hourly,alerts&appid=1f9e3e9566eedd283a4f137c0543c422&units=imperial")
        request.responseJSON(completionHandler: {(data) in
            if let json = data.value as? [String:Any] {
                let dailyForecast = json["daily"] as! NSArray
                for day in dailyForecast {
                    if let dat = day as? NSDictionary {
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
        return String(temp) + "°"
    }
    
    func descriptionString() -> String {
        return "\(humidity)% and \(description) in Sunnyvale"
    }
}
