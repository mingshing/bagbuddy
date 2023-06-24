//
//  ItemNotePresenter.swift
//  bagbuddy
//
//  Created by mingshing on 2023/6/17.
//

import Foundation

protocol ItemNotePresenterDelegate: AnyObject {
    func updateNote(text: String)
}

protocol ItemNotePresenterType: AnyObject {
    
    var delegate: ItemNotePresenterDelegate? {get set}
    func saveNote(text: String)
}


class ItemNotePresenter: ItemNotePresenterType {
    weak var delegate: ItemNotePresenterDelegate?
    
    init(delegate: ItemNotePresenterDelegate? = nil) {
        
        self.delegate = delegate
    }
    
    func saveNote(text: String) {
        delegate?.updateNote(text: text)
    }
    
}
