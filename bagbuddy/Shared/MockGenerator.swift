//
//  MockGenerator.swift
//  bagbuddy
//
//  Created by mingshing on 2023/5/13.
//

import Foundation

class MockGenerator {
    
    static let mockTripDetailList: TripDetailList = TripDetailList(
        source: City(name: "Taipei", country: "Taiwan"),
        destination: City(name: "Tokyo", country: "Japan"),
        lowTemperature: 20,
        highTemperature: 22,
        activityList: mockActivityList
    )
    
    static let mockActivityList = [activityNightMarket, ferryRide]
    
    static var activityNightMarket = Activity(
        name: "Temple Street Night Market",
        items: [itemMap, itemCamera]
    )
    static var ferryRide = Activity(
        name: "Star Ferry ride",
        items: [itemCash,itemShoe]
    )
    
    static var itemCash = Item(name: "cash")
    static var itemMap = Item(name: "map")
    static var itemCamera = Item(name: "camera")
    static var itemShoe = Item(name: "comfortable shoes")
}
