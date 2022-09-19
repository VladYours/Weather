//
//  City.swift
//  weather
//
//  Created by Vlad Rakovich on 16.09.2022.
//

import Foundation

struct CityItem: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord:  Coord
}
