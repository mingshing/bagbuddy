//
//  FirstStepPresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation

protocol SelectLocationDelegate: AnyObject {
    func showLocationListPage()
    func enterNextStep()
}


protocol SelectLocationPresenterType {
    var delegate: SelectLocationDelegate? {get set}
    func nextStep()
    func openSelectCityPage()
}

class SelectLocationPresenter: SelectLocationPresenterType {
    
    weak var delegate: SelectLocationDelegate?
    private var selectedCityName: String?
    
    init(delegate: SelectLocationDelegate? = nil) {
        
        self.delegate = delegate
    }
    
    func nextStep() {
        delegate?.enterNextStep()
    }
    
    func openSelectCityPage() {
        delegate?.showLocationListPage()
    }
}
    
