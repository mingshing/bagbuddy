//
//  City.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation

struct City: Codable {
    let name: String
    let country: String
    
    var displayName: String {
        return name + "," + country
    }
}
