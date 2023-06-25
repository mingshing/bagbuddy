//
//  ItemNoteViewModel.swift
//  bagbuddy
//
//  Created by mingshing on 2023/6/24.
//

import Foundation
struct ItemNoteViewModel{
    let name: String
    let indexPath: IndexPath
    var note: String?
    
    
    init(name: String, for indexPath: IndexPath, note: String? = nil) {
        self.indexPath = indexPath
        self.name = name
        self.note = note
    }
}
