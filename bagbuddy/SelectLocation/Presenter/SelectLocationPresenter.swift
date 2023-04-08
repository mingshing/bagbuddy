//
//  FirstStepPresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation

protocol SelectLocationDelegate: AnyObject {
    func nextStep()
}


protocol SelectLocationPresenterType {
    var delegate: SelectLocationDelegate? {get set}
    
    func openSelectCityPage()
}

class SelectLocationPresenter: SelectLocationPresenterType {
    
    weak var delegate: SelectLocationDelegate?
    private var selectedCityName: String?
    
    init(delegate: SelectLocationDelegate? = nil) {
        
        self.delegate = delegate
    }
    
    func openSelectCityPage() {
        delegate?.nextStep()
    }
}
    
