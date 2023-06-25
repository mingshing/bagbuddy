//
//  PackageListViewModel.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation

struct PackageListViewModel {
    let tripDestination: String
    let startDate: String
    let endDate: String
    let categorySection: SectionHeaderViewModel
    let packItemSection: SectionHeaderViewModel
    let activyListSection: ActivityListViewModel
    var activitiesSections: [ActivitySectionViewModel] 
    var tagListViewModel: TagListCellViewModel
    var itemViewModels: [[PackageItemCellViewModel]]
    init(
        tripDestination: String,
        startDate: String,
        endDate: String,
        categorySection: SectionHeaderViewModel,
        packItemSection: SectionHeaderViewModel,
        activyListSection: ActivityListViewModel,
        activitiesSections: [ActivitySectionViewModel]
    ) {
        self.tripDestination = tripDestination
        self.startDate = startDate
        self.endDate = endDate
        self.categorySection = categorySection
        self.packItemSection = packItemSection
        self.activyListSection = activyListSection
        self.activitiesSections = activitiesSections
        self.tagListViewModel = TagListCellViewModel(tags: activyListSection.activityNames)
        self.itemViewModels = PackageListViewModel.generateItemCellViewModels(activitiesSections)
    }
    
    static func generateItemCellViewModels(_ source: [ActivitySectionViewModel]) -> [[PackageItemCellViewModel]] {
        var itemViewModelArray: [[PackageItemCellViewModel]] = []
        for activityViewModel in source {
            var sectionItems:[PackageItemCellViewModel] = []
            for item in activityViewModel.activity.items {
                sectionItems.append(
                    PackageItemCellViewModel(
                        name: item.name,
                        note: item.note
                    )
                )
            }
            itemViewModelArray.append(sectionItems)
        }
        return itemViewModelArray
    }
}
