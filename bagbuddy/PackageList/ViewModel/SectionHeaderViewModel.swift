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

struct ActivityListViewModel {
    var activities: [Activity]
    var activityNames: [String] {
        activities.map { $0.name }
    }
}

struct ActivitySectionViewModel {
    var activity: Activity
    var displayState: ItemSectionState
    var title: String {
        return activity.name
    }
    var itemCount: Int {
        return activity.items.count
    }
    
    init(activity: Activity) {
        self.activity = activity
        self.displayState = .close
    }
}

