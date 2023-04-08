//
//  LocationListViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation
import SnapKit
import UIKit

class LocationListViewController: UIViewController {

    //MARK: view related
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.projectFont(ofSize: 28, weight: .bold)
        label.textColor = .primaryBlack
        return label
    }()
    
    init(target: SelectTargetLocation) {
        super.init(nibName: nil, bundle: nil)
        
        self.navigationTitleLabel.text = target.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(4)
            make.size.equalTo(48)
        }
        
        view.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
        }
        
    }
    @objc func didTapClose(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
   }
}
