//
//  LocationListViewPresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation

protocol LocationListPresenterDelegate: AnyObject {
    
    func didUpdateViewModel()
}

protocol LocationListPresenterType: AnyObject {
    var delegate: LocationListPresenterDelegate? {get set}
    func numberOfItems() -> Int
    func updateItems(with text: String?)
    func viewModelForIndex(at index: Int) -> LocationListCellViewModel?
}


class LocationListPresenter: LocationListPresenterType {
    
    weak var delegate: LocationListPresenterDelegate?
    var cellViewModels: [LocationListCellViewModel] = [] {
        didSet {
            delegate?.didUpdateViewModel()
        }
    }
    
    init(delegate: LocationListPresenterDelegate? = nil) {
        self.delegate = delegate
        cellViewModels = getAllAvailableCityViewModels()
    }
    
    func updateItems(with text: String?) {
        guard let inputText = text,
              !inputText.isEmpty else {
            cellViewModels = getAllAvailableCityViewModels()
            return
        }
        cellViewModels = getAllAvailableCityViewModels(filterText: text)
    }
    
    func numberOfItems() -> Int {
        return cellViewModels.count
    }
    
    func viewModelForIndex(at index: Int) -> LocationListCellViewModel? {
        guard index < cellViewModels.count else { return nil }
        return cellViewModels[index]
    }
    
    private func getAllAvailableCityViewModels(filterText: String? = nil) -> [LocationListCellViewModel] {
        guard let cityList = LocalDataManager().getCityList() else {
            return []
        }
        guard let filterText = filterText else {
            return cityList.map { city in
                LocationListCellViewModel(locationName: city.displayName)
            }
        }
        return cityList
            .filter { city in
                city.displayName.contains(filterText)
            }.map { city in
                LocationListCellViewModel(locationName: city.displayName)
            }
    }
}
