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
    func updateActivitiesSection(section: Int)
}

protocol PackageListPresenterType: AnyObject {
    var viewModel: PackageListViewModel { get set }
    func setupHeader()
    func setupContent()
    func numberOfSections() -> Int
    func numberOfItemSections() -> Int
    func numberOfItems(for section: Int) -> Int
    
    func removeItemSection(with title: String) -> Int
    
    func viewModelForItemSection(at section: Int) -> ActivitySectionViewModel?
    func changeItemSectionState(section: Int, fromState: ItemSectionState)
    func viewModelForIndex(at indexPath: IndexPath) -> ReuseableCellViewModel?
    func updateItemViewModelForIndex(_ viewModel: PackageItemCellViewModel, at indexPath: IndexPath)
}

class PackageListPresenter: PackageListPresenterType {
    
    private weak var delegate: PackageListPresenterDelegate?
    var viewModel: PackageListViewModel
    
    init(with viewModel: PackageListViewModel, delegate: PackageListPresenterDelegate? = nil) {
        self.delegate = delegate
        self.viewModel = viewModel
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
            let activity = viewModel.activitiesSections[startIdx]
            if activity.displayState == .close {
                return 0
            }
            return viewModel.itemViewModels[startIdx].count
        }
    }
    
    
    // remove the section with same title name, and return the section index
    func removeItemSection(with title: String) -> Int {
        let itemStartIdx = PackageListSection.itemList.rawValue
        for(idx, model) in viewModel.activitiesSections.enumerated().reversed() {
            if model.title == title {
                viewModel.activitiesSections.remove(at: idx)
                return idx + itemStartIdx
            }
        }
        return -1
    }
    
    func viewModelForItemSection(at section: Int) -> ActivitySectionViewModel? {
        let itemStartIdx = PackageListSection.itemList.rawValue
        guard section - itemStartIdx >= 0 else {
            return nil
        }
        return viewModel.activitiesSections[section - itemStartIdx]
    }
    
    func changeItemSectionState(section: Int, fromState: ItemSectionState) {
        let itemStartIdx = PackageListSection.itemList.rawValue
        if var sectionViewModel = viewModelForItemSection(at: section) {
            if fromState == .close {
                sectionViewModel.displayState = .open
            } else if fromState == .open {
                sectionViewModel.displayState = .close
            }
            viewModel.activitiesSections[section - itemStartIdx] = sectionViewModel
            delegate?.updateActivitiesSection(section: section)
        }
    }
    
    
    func viewModelForIndex(at indexPath: IndexPath) -> ReuseableCellViewModel? {
        
        if indexPath.section == PackageListSection.customizeTrip.rawValue {
            return viewModel.tagListViewModel
        } else if indexPath.section >= PackageListSection.itemList.rawValue {
            
            let startIdx = indexPath.section - PackageListSection.itemList.rawValue
            
            guard viewModel.activitiesSections.count > startIdx,
                  viewModel.activitiesSections[startIdx].itemCount > indexPath.row else { return nil }
            return viewModel.itemViewModels[startIdx][indexPath.row]
        }
        return nil
    }
    
    func updateItemViewModelForIndex(_ updateViewModel: PackageItemCellViewModel, at indexPath: IndexPath) {
        
        guard indexPath.section >= PackageListSection.itemList.rawValue else { return }
        
        let startIdx = indexPath.section - PackageListSection.itemList.rawValue
        viewModel.itemViewModels[startIdx][indexPath.row] = updateViewModel
    }
}
