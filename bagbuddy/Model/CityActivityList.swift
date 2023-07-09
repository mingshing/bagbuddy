//
//  Activity.swift
//  bagbuddy
//
//  Created by mingshing on 2023/5/8.
//

import Foundation

struct CityActivityList: Codable {
    let activities: [Activity]
    let name: String
    let currency: String
    let powerAdapter: String
    let note: String
    
    
    enum CodingKeys: String, CodingKey {
        case activities, name, currency, note
        case powerAdapter = "power_adapter"
    }
}
