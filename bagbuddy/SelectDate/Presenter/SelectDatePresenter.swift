//
//  SelectDatePresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import HorizonCalendar
import Foundation

protocol SelectDatePresenterDelegate: AnyObject {
    func showDatePicker()
    func enterPackageList()
}

protocol SelectDatePresenterType {
    var delegate: SelectDatePresenterDelegate? {get set}
    var selectedDayRange: DayRange? {get set}
    func openDatePicker()
    func openPackageListPage()
}

class SelectDatePresenter: SelectDatePresenterType {
    
    weak var delegate: SelectDatePresenterDelegate?
    
    var selectedDayRange: DayRange?
    
    init(delegate: SelectDatePresenterDelegate? = nil) {
        
        self.delegate = delegate
    }
    
    func openDatePicker() {
        delegate?.showDatePicker()
    }
    
    func openPackageListPage() {
        guard let selectedDayRange = selectedDayRange  else { return }
        let startDateComponents = selectedDayRange.lowerBound.components
        let endDateComponents = selectedDayRange.upperBound.components
        let calendar = Calendar.current
        
        if let startDate = calendar.date(from: startDateComponents),
           let endDate = calendar.date(from: endDateComponents) {
            TripPacker.shared.currentPlannedTrip?.startDate = startDate
            TripPacker.shared.currentPlannedTrip?.endDate = endDate
            
            delegate?.enterPackageList()
        }
    }
}
