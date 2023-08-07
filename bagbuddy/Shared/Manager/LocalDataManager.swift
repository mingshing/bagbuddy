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
    
    public func getActivityItemDomainInfo() -> [String: CityInfoList]? {
        
        if let url = Bundle.main.url(forResource: LocalFileName.suggestItemList, withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               let cityInfos = try decoder.decode([CityInfoList].self, from: data)
               return Dictionary(uniqueKeysWithValues: cityInfos.map {
                   let travelMonth = $0.month.lowercased()
                   let cityName = $0.name.lowercased()
                   let searchKey = cityName + "_" + travelMonth
                   return (searchKey, $0)
               })
           } catch {
               print("error: \(error)")
           }
        }
        return nil
    }
    
    public func getDefaultEssential(_ country: String) -> Activity {
        if let url = Bundle.main.url(forResource: LocalFileName.essentialItemList, withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               var essentialActivity = try decoder.decode(Activity.self, from: data)
               if let cityInfos = getActivityItemDomainInfo(),
                  let tagetCountryInfo = cityInfos[country] {
                   for (idx,item) in essentialActivity.items.enumerated() {
                       if item.name == "Cash" {
                           essentialActivity.items[idx].note = tagetCountryInfo.currency
                       }
                   }
               }
               return essentialActivity
           } catch {
               print("error: \(error)")
           }
        }
        return Activity(name: "Essential")
    }
    
    public func getDefaultInternalTrip(_ country: String) -> Activity {
        if let url = Bundle.main.url(forResource: LocalFileName.interNationalTripItemList, withExtension: "json") {
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               var nationalActivity = try decoder.decode(Activity.self, from: data)
               if let cityInfos = getActivityItemDomainInfo(),
                  let tagetCountryInfo = cityInfos[country] {
                   for (idx,item) in nationalActivity.items.enumerated() {
                       if item.name == "Power adaptor" {
                           nationalActivity.items[idx].note = tagetCountryInfo.powerAdapter
                       }
                   }
               }
               return nationalActivity
           } catch {
               print("error: \(error)")
           }
        }
        return Activity(name: "International trip")
    }
}
