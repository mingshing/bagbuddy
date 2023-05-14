//
//  TripHeaderView.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/23.
//

import Foundation
import UIKit


class TripHeaderView: UIView {

// MARK: View Related
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .mainHeaderBackground
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(48)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    public func updateView(with viewModel: PackageListViewModel) {
        titleLabel.text = viewModel.tripDestination
        dateLabel.text = viewModel.startDate + " - " + viewModel.endDate
        layoutIfNeeded()
    }
}
