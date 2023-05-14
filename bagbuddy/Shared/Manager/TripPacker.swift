//
//  TripPacker.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation

struct Activity: Codable {
    let name: String
    var items: [Item]
    
    init(name: String, items: [Item] = []) {
        self.name = name
        self.items = items
    }
}

struct Item: Codable {
    let name: String
    var note: String?
    var count: Int?
    
    init(name: String, note: String? = nil, count: Int = 1) {
        self.name = name
        self.note = note
        self.count = count
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
        //currentPlannedTrip = TripDetailList()
        currentPlannedTrip = MockGenerator.mockTripDetailList
    }
}
