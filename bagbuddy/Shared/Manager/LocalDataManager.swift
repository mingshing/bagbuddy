//
//  LocalDataManager.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation
import RealmSwift

class LocalDataManager {
    
    public static let shared = LocalDataManager()
    
    public func getCityList() -> [City]? {
        
        if let url = Bundle.main.url(forResource: LocalFileName.cityList, withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               let cities = try decoder.decode([City].self, from: data)
               return cities
           } catch {
               print("error: \(error)")
           }
        }
        return nil
    }
    
    public func getActivityItemDomainModel() -> [String: [Activity]]? {
        
        if let url = Bundle.main.url(forResource: LocalFileName.suggestItemList, withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               let cityActivities = try decoder.decode([CityActivityList].self, from: data)
               return Dictionary(uniqueKeysWithValues: cityActivities.map { ($0.name, $0.activities) })
           } catch {
               print("error: \(error)")
           }
        }
        return nil
    }
}
