//
//  Date+Extensions.swift
//  bagbuddy
//
//  Created by mingshing on 2023/7/10.
//

import Foundation

extension Date {
    
    func format(with dateStyle: String, locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateStyle
        dateFormatter.locale = locale
            
        return dateFormatter.string(from: self)
    }
    
    func format(with dateStyle: String) -> String {
        return format(with: dateStyle, locale: Locale(identifier: "en_US"))
    }
}
