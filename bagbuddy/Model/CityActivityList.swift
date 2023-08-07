//
//  Activity.swift
//  bagbuddy
//
//  Created by mingshing on 2023/5/8.
//

import Foundation

struct CityInfoList: Codable {
    let activities: [Activity]
    let name: String
    let currency: String
    let powerAdapter: String
    let month: String
    let note: String
    
    
    enum CodingKeys: String, CodingKey {
        case activities, name, currency, note, month
        case powerAdapter = "power_adapter"
    }
}
