//
//  SectionHeaderViewModel.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/24.
//

import Foundation

struct SectionHeaderViewModel {
    let title: String
    let description: String
}

struct ItemSectionHeaderViewModel {
    let title: String
    let itemCount: Int
    let sectionState: ItemSectionState
    
    init(title: String, itemCount: Int) {
        self.title = title
        self.itemCount = itemCount
        self.sectionState = .close
    }
}
