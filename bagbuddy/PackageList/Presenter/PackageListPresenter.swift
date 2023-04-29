//
//  PackageListPresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation

protocol PackageListPresenterDelegate: AnyObject {
    func update(with viewModel: PackageListViewModel?)
}

protocol PackageListPresenterType: AnyObject {
    var hiddenSections: Set<Int> { get set }
    func fetchData()
    func numberOfSections() -> Int
    func numberOfItems(for section: Int) -> Int
    
    func indexPathsForSection(for section: Int) -> [IndexPath]
    func viewModelForIndex(at indexPath: IndexPath) -> PackageItemCellViewModel?
}

class PackageListPresenter: PackageListPresenterType {
    
    private weak var delegate: PackageListPresenterDelegate?
    var viewModel: PackageListViewModel?
    var hiddenSections: Set<Int>
    
    let tableViewData = [
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
    ]
    
    init(delegate: PackageListPresenterDelegate? = nil) {
        self.delegate = delegate
        self.hiddenSections = Set<Int>()
    }
    
    public func fetchData() {
        ChatGPTService.getResponseFromChatGPT(for: "test") { [weak self] result in
            guard let _ = self else { return }
            
            print(result)
        }
        viewModel = buildViewModel()
        delegate?.update(with: viewModel)
    }
    
    
    private func buildViewModel() -> PackageListViewModel? {
        
        guard let destination = TripPacker.shared.currentPlannedTrip?.destination else { return nil }
        let categorySectionViewModel = SectionHeaderViewModel(
            title: "Customize your trip",
            description: "What will you be doing on this trip?"
        )
        
        let packItemSectionViewModel = SectionHeaderViewModel(
            title: "Start packing",
            description: "Your AI generated packing list:"
        )
        return PackageListViewModel(
            tripDestination: destination,
            startDate: "Mar 21",
            endDate: "Mar 23",
            categorySection: categorySectionViewModel,
            packItemSection: packItemSectionViewModel
        )
    }
}

extension PackageListPresenter {
    
    func numberOfSections() -> Int {
        return tableViewData.count
    }
    
    func numberOfItems(for section: Int) -> Int {
        guard tableViewData.count > section else { return 0 }
        if hiddenSections.contains(section) {
            return 0
        }
        return tableViewData[section].count
    }
    
    func indexPathsForSection(for section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for row in 0..<tableViewData[section].count {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        
        return indexPaths
    }
    
    func viewModelForIndex(at indexPath: IndexPath) -> PackageItemCellViewModel? {
        
        guard tableViewData.count > indexPath.section,
              tableViewData[indexPath.section].count > indexPath.row else { return nil }
        
        return PackageItemCellViewModel(name: tableViewData[indexPath.section][indexPath.row])
    }
}
