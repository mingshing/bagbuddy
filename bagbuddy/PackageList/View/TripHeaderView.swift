//
//  TripHeaderView.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/23.
//

import Foundation
import UIKit

protocol TripHeaderViewDelegate: AnyObject {
    func didTapCloseButton()
}


class TripHeaderView: UIView {

// MARK: View Related

    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.projectFont(ofSize: 28, weight: .bold)
        label.textColor = .primaryBlack
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.actionTextFont(ofSize: 14)
        label.textColor = .primaryBlack
        return label
    }()
    
    private weak var delegate: TripHeaderViewDelegate?
    
    init(delegate: TripHeaderViewDelegate? = nil) {
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = .mainHeaderBackground
        self.delegate = delegate
        setupView()
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(LayoutConstants.actionButtonHeight)
            make.left.equalToSuperview().inset(4)
            make.top.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(closeButton.snp.bottom).offset(8)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    @objc func didTapClose(sender: UIButton!) {
        delegate?.didTapCloseButton()
        
    }
    
    public func updateView(with viewModel: PackageListViewModel) {
        titleLabel.text = viewModel.tripDestination
        dateLabel.text = viewModel.startDate + " - " + viewModel.endDate
    }
}
