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
    let activitiesSections: ActivitySectionViewModel
    let itemsSections: [ItemSectionViewModel]
}
