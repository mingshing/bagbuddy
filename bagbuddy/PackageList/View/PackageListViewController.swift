//
//  PackageListViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import SnapKit
import UIKit

class PackageListViewController: UIViewController {
    
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
        self.view.backgroundColor = .green
    }
    
}
