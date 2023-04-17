//
//  TripPacker.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation

struct Activity {
    let name: String
    var suggestPackedItems: [Item]
    
    init(name: String) {
        self.name = name
        suggestPackedItems = []
    }
}

struct Item {
    let name: String
    var count: Int
    var checked: Bool
    
    init(name: String, count: Int = 1, checked: Bool = false) {
        self.name = name
        self.count = count
        self.checked = checked
    }
}

struct TripDetailList {
    var source: String?
    var destination: String?
    var lowTemperature: Int?
    var highTemperature: Int?
    var activityList: [Activity]?
}


class TripPacker {
    
    public static let shared = TripPacker()
    
    var currentPlannedTrip: TripDetailList?
    
    public func startNewTrip() {
        currentPlannedTrip = TripDetailList()
    }
}
