//
//  SelectDatePresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation

protocol SelectDateDelegate: AnyObject {
    func showDatePicker()
    func enterPackageList()
}

protocol SelectDatePresenterType {
    var delegate: SelectDateDelegate? {get set}
    func openDatePicker()
    func openTripMainPage()
}

class SelectDatePresenter: SelectDatePresenterType {
    
    weak var delegate: SelectDateDelegate?
    
    init(delegate: SelectDateDelegate? = nil) {
        
        self.delegate = delegate
    }
    
    func openDatePicker() {
        delegate?.showDatePicker()
    }
    
    func openTripMainPage() {
        delegate?.enterPackageList()
    }
}
