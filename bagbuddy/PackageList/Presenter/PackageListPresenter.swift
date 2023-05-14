//
//  PackageListPresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation

protocol PackageListPresenterDelegate: AnyObject {
    func updateHeaderView(with viewModel: PackageListViewModel)
    func updateContent(with viewModel: PackageListViewModel)
}

protocol PackageListPresenterType: AnyObject {
    var hiddenSections: Set<Int> { get set }
    func setupHeader()
    func setupContent()
    func numberOfSections() -> Int
    func numberOfItemSections() -> Int
    func numberOfItems(for section: Int) -> Int
    
    func viewModelForItemSection(at section: Int) -> ActivitySectionViewModel?
    func viewModelForIndex(at indexPath: IndexPath) -> ReuseableCellViewModel?
}

class PackageListPresenter: PackageListPresenterType {
    
    private weak var delegate: PackageListPresenterDelegate?
    var viewModel: PackageListViewModel
    var hiddenSections: Set<Int>
    
    init(with viewModel: PackageListViewModel, delegate: PackageListPresenterDelegate? = nil) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.hiddenSections = Set<Int>()
    }
    
    func setupHeader() {
        delegate?.updateHeaderView(with: viewModel)
    }
    
    func setupContent() {
        delegate?.updateContent(with: viewModel)
    }
}

extension PackageListPresenter {
    
    func numberOfSections() -> Int {
        return numberOfItemSections() + PackageListSection.itemList.rawValue
    }
    
    func numberOfItemSections() -> Int {
        return viewModel.activitiesSections.count
    }
    
    
    func numberOfItems(for section: Int) -> Int {
        if section == PackageListSection.customizeTrip.rawValue {
            return 1
        } else if section == PackageListSection.startPacking.rawValue {
            return 0
        } else {
            let startIdx = section - PackageListSection.itemList.rawValue
            if hiddenSections.contains(section) {
                return 0
            }
            let activity = viewModel.activitiesSections[startIdx]
            return activity.itemCount
        }
    }
    
    func viewModelForItemSection(at section: Int) -> ActivitySectionViewModel? {
        let itemStartIdx = PackageListSection.itemList.rawValue
        guard section - itemStartIdx >= 0 else {
            return nil
        }
        
        return viewModel.activitiesSections[section - itemStartIdx]
    }
    
    func viewModelForIndex(at indexPath: IndexPath) -> ReuseableCellViewModel? {
        
        if indexPath.section == PackageListSection.customizeTrip.rawValue {
            // TODO: get the real data from local / chatgpt
            return TagListCellViewModel(tags: ["Inboard", "Pomotodo", "Halo Word"])
        } else if indexPath.section >= PackageListSection.itemList.rawValue {
            
            let startIdx = indexPath.section - PackageListSection.itemList.rawValue
            
            guard viewModel.activitiesSections.count > startIdx,
                  viewModel.activitiesSections[startIdx].itemCount > indexPath.row else { return nil }
            
            let activity = viewModel.activitiesSections[startIdx].activity
            let packageItem = activity.items[indexPath.row]
            return PackageItemCellViewModel(
                name: packageItem.name,
                note: packageItem.note
            )
        }
        return nil
    }
}
