//
//  SelectDatePresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation

protocol SelectDatePresenterDelegate: AnyObject {
    func showDatePicker()
    func enterPackageList()
}

protocol SelectDatePresenterType {
    var delegate: SelectDatePresenterDelegate? {get set}
    func openDatePicker()
    func openPackageListPage()
}

class SelectDatePresenter: SelectDatePresenterType {
    
    weak var delegate: SelectDatePresenterDelegate?
    
    init(delegate: SelectDatePresenterDelegate? = nil) {
        
        self.delegate = delegate
    }
    
    func openDatePicker() {
        delegate?.showDatePicker()
    }
    
    func openPackageListPage() {
        delegate?.enterPackageList()
    }
}
