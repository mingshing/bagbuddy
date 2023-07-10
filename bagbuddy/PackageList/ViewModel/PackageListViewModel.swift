//
//  PackageListViewModel.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation

struct PackageListViewModel {
    
    static func defaultItemCellViewModels(_ source: [ActivitySectionViewModel]) -> [[PackageItemCellViewModel]] {
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
    
    
    let tripDestination: String
    let startDate: String
    let endDate: String
    let contryNote: String
    let categorySection: SectionHeaderViewModel
    let packItemSection: SectionHeaderViewModel
    let activyListSection: ActivityListViewModel
    var activitiesSections: [ActivitySectionViewModel]
    var tagListViewModel: TagListCellViewModel
    var itemViewModels: [[PackageItemCellViewModel]]
    var selectedActivityTitle: [String]
    init(
        tripDestination: String,
        startDate: String,
        endDate: String,
        countryNote: String,
        categorySection: SectionHeaderViewModel,
        packItemSection: SectionHeaderViewModel,
        activyListSection: ActivityListViewModel,
        activitiesSections: [ActivitySectionViewModel]
    ) {
        self.tripDestination = tripDestination
        self.startDate = startDate
        self.endDate = endDate
        self.contryNote = countryNote
        self.categorySection = categorySection
        self.packItemSection = packItemSection
        self.activyListSection = activyListSection
        self.activitiesSections = activitiesSections
        self.tagListViewModel = TagListCellViewModel(tags: activyListSection.activityNames)
        self.itemViewModels = PackageListViewModel.defaultItemCellViewModels(activitiesSections)
        self.selectedActivityTitle = []
    }
    
    mutating func addNewActivityItemModels(from viewModel: ActivitySectionViewModel) {
        var sectionItems:[PackageItemCellViewModel] = []
        for item in viewModel.activity.items {
            sectionItems.append(
                PackageItemCellViewModel(
                    name: item.name,
                    note: item.note
                )
            )
        }
        itemViewModels.append(sectionItems)
    }
    
    mutating func removeActivityItemModels(at idx: Int) {
        itemViewModels.remove(at: idx)
    }
}
