//
//  WeatherDataModel.swift
//  RegistrationPageTask
//
//  Created by Hayk Harutyunyan on 6/30/17.
//  Copyright © 2017 MacBook. All rights reserved.
//
import Alamofire
class WeatherDataModel {
    private var _date: Double?
    private var _temp: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Yerevan&appid=a7bbbd5e82c675f805e7ae084f742024")!

    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: _date!)
        return (dateFormatter.string(from: date))
    }
    
    var temp: String {
        return _temp ?? "something went wrong"
    }
    
    func downloadData(completed: @escaping ()-> ()) {
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard,
                let main = dict["main"] as? JSONStandard,
                let temp = main["temp"] as? Double,
                let dt = dict["dt"] as? Double {
                
                self._temp = String(format: "%.0f °C", temp - 273.15)
                self._date = dt
            }
            
            completed()
        })
    }
}
