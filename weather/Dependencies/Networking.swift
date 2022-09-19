//
//  Networking.swift
//  weather
//
//  Created by Vlad Rakovich on 18.09.2022.
//

import Foundation
import UIKit
import Alamofire


protocol Networking {
    typealias functionOnSuccess = (WeatherAnswerByGPS) -> Void
    func getWeather(GPSCoord: Coord, appid: String, view: UIView, successRes: @escaping functionOnSuccess)
}

struct Request: Networking {
    func getWeather(GPSCoord: Coord, appid: String, view: UIView, successRes: @escaping functionOnSuccess) {
        view.isHidden = false
        let url = "http://api.openweathermap.org/data/2.5/forecast"
        let appid = "3e02bd506073cd159006874c4b47d5dd"
        let parameters: [String: Any] = [
            "lat": GPSCoord.lat,
            "lon": GPSCoord.lon,
            "appid": appid,
            "units": "metric",
            "lang": "ua"
        ]
        AF.request(url, parameters: parameters)
            .response(){response in
//                debugPrint(response)
            }
            .responseDecodable(of: WeatherAnswerByGPS.self) { response in
//            debugPrint("Response: \(response)")
                view.isHidden = true
            switch response.result {
                    case .success:
                        guard let info = response.value else {
                            print("Error when get value from network response")
                            return
                        }
                        successRes(info)
                    case .failure(_):
                        print("Response failure")
                        return
                    } //END Switch
        }//END AF
    }
    
}
