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
    
    func fetchData()
}

class PackageListPresenter: PackageListPresenterType {
    
    private weak var delegate: PackageListPresenterDelegate?
    var viewModel: PackageListViewModel?
    
    init(delegate: PackageListPresenterDelegate? = nil) {
        self.delegate = delegate
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
