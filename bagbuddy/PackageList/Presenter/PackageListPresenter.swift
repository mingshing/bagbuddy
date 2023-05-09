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
    
    func viewModelForItemSection(at section: Int) -> ItemSectionViewModel
    func viewModelForIndex(at indexPath: IndexPath) -> ReuseableCellViewModel?
}

class PackageListPresenter: PackageListPresenterType {
    
    private weak var delegate: PackageListPresenterDelegate?
    var viewModel: PackageListViewModel
    var hiddenSections: Set<Int>
    
    let tableViewData = [
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
    ]
    
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
        return viewModel.itemsSections.count
    }
    
    
    func numberOfItems(for section: Int) -> Int {
        if section == PackageListSection.customizeTrip.rawValue {
            return 0
        } else if section == PackageListSection.startPacking.rawValue {
            return 1
        } else {
            
            guard tableViewData.count > section else { return 0 }
            if hiddenSections.contains(section) {
                return 0
            }
        }
        return 0
    }
    
    func viewModelForItemSection(at section: Int) -> ItemSectionViewModel {
        let itemStartIdx = PackageListSection.itemList.rawValue
        return viewModel.itemsSections[section - itemStartIdx]
    }
    
    func viewModelForIndex(at indexPath: IndexPath) -> ReuseableCellViewModel? {
        
        guard indexPath.section > PackageListSection.customizeTrip.rawValue else { return nil }
        if indexPath.section == PackageListSection.startPacking.rawValue {
            
            return TagListCellViewModel(tags: ["Inboard", "Pomotodo", "Halo Word"])
        } else if indexPath.section == PackageListSection.itemList.rawValue {
            
            guard tableViewData.count > indexPath.section,
                  tableViewData[indexPath.section].count > indexPath.row else { return nil }
            
            return PackageItemCellViewModel(name: tableViewData[indexPath.section][indexPath.row])
        }
        return nil
    }
}
