//
//  DatePickerViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation
import HorizonCalendar
import SnapKit
import UIKit

class DatePickerViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .red
    }
    
}
