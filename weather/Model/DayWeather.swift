//
//  DayWeather.swift
//  weather
//
//  Created by Vlad Rakovich on 17.09.2022.
//

import Foundation
import UIKit

struct DayWeather {
    let name: String
    let minT: Int
    let maxT: Int
    let img: String
    let hours: [InHourWeather]
}
