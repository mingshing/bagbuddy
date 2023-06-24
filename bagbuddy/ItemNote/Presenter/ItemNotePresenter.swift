//
//  ItemNotePresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/6/17.
//

import Foundation

protocol ItemNotePresenterType: AnyObject {
    func saveNote(text: String)
}


class ItemNotePresenter: ItemNotePresenterType {
    
    
    init() {
    
    }
    
    func saveNote(text: String) {
       // delegate?.updateNote(text: text)
    }
    
}
