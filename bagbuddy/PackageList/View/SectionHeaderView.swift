//
//  SectionHeaderView.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/24.
//

import Foundation
import UIKit

class SectionHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.projectFont(ofSize: 16, weight: .bold)
        label.textColor = .primaryBlack
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.actionTextFont(ofSize: 14)
        label.textColor = .primaryBlack
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
    }
    
    public func updateView(with viewModel: SectionHeaderViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
