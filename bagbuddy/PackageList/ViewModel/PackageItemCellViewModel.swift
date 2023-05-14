//
//  PackageItemCellViewModel.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/24.
//

import Foundation

protocol ReuseableCellViewModel { }

struct PackageItemCellViewModel: ReuseableCellViewModel{
    let name: String
    var note: String?
    var checked: Bool
    
    init(name: String, note: String? = nil, checked: Bool = false) {
        self.name = name
        self.note = note
        self.checked = checked
    }
}
