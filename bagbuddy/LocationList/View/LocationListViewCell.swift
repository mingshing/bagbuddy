//
//  LocationListViewCell.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/15.
//

import Foundation
import UIKit

class LocationListViewCell: UITableViewCell {
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .actionTextFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .primaryBlack
        label.text = "Taipei, Taiwan"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    public func update(with viewModel: LocationListCellViewModel) {
        locationNameLabel.text = viewModel.location.displayName
    }
    
}
