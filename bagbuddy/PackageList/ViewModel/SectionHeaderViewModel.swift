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

struct ActivitySectionViewModel {
    var activities: [Activity]
    var itemCount: Int {
        return activities.count
    }
    
    init(activities: [Activity] = []) {
        self.activities = activities
    }
}



struct ItemSectionViewModel {
    let title: String
    let sectionState: ItemSectionState
    var items: [Item]
    var itemCount: Int {
        return items.count
    }
    
    init(title: String, items: [Item] = []) {
        self.title = title
        self.sectionState = .close
        self.items = items
    }
}
