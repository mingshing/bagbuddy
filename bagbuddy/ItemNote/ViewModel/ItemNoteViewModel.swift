//
//  ItemNoteViewModel.swift
//  bagbuddy
//
//  Created by mingshing on 2023/6/24.
//

import Foundation
struct ItemNoteViewModel{
    let name: String
    var note: String?
    
    
    init(name: String, note: String? = nil) {
        self.name = name
        self.note = note
    }
}
