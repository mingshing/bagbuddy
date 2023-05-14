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
    var activityNames: [String]
}

struct ActivitySectionViewModel {
    var activity: Activity
    var title: String {
        return activity.name
    }
    var itemCount: Int {
        return activity.items.count
    }
    
    init(activity: Activity) {
        self.activity = activity
    }
}

