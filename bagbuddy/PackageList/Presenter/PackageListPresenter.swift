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
    
    func viewModelForSection(at section: Int) -> ItemSectionHeaderViewModel
    func viewModelForIndex(at indexPath: IndexPath) -> PackageItemCellViewModel?
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
        return numberOfItemSections() + 2
    }
    
    func numberOfItemSections() -> Int {
        return viewModel.itemsSections.count
    }
    
    
    func numberOfItems(for section: Int) -> Int {
        guard tableViewData.count > section else { return 0 }
        if hiddenSections.contains(section) {
            return 0
        }
        return 0
    }
    
    func viewModelForSection(at section: Int) -> ItemSectionHeaderViewModel {
        return viewModel.itemsSections[section]
    }
    
    func viewModelForIndex(at indexPath: IndexPath) -> PackageItemCellViewModel? {
        
        guard tableViewData.count > indexPath.section,
              tableViewData[indexPath.section].count > indexPath.row else { return nil }
        
        return PackageItemCellViewModel(name: tableViewData[indexPath.section][indexPath.row])
    }
}
