//
//  TripHeaderView.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/23.
//

import Foundation
import UIKit


protocol TripHeaderViewDelegate: AnyObject {
    func didReloadContent(_ view: TripHeaderView)
}

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
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .left
        label.font = UIFont.actionTextFont(ofSize: 14)
        label.textColor = .primaryBlack
        label.sizeToFit()
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("See more", for: .normal)
        button.setTitleColor(UIColor.mainItemOrange, for: .normal)
        button.titleLabel?.font = UIFont.actionTextFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        return button
    }()
    
    private var delegate: TripHeaderViewDelegate?
    
    init(delegate: TripHeaderViewDelegate) {
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = .mainHeaderBackground
        self.delegate = delegate
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(DeviceConstants.width - 40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        addSubview(noteLabel)
        noteLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(noteLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    public func updateView(with viewModel: PackageListViewModel) {
        titleLabel.text = viewModel.tripDestination
        dateLabel.text = viewModel.startDate + " - " + viewModel.endDate
        noteLabel.text = viewModel.contryNote
    }
    
    @objc func didTapMore() {
        expandHeaderView()
    }
    
    private func expandHeaderView() {
        noteLabel.numberOfLines = 0
        noteLabel.sizeToFit()
        
        noteLabel.snp.remakeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(24)
        }
        moreButton.removeFromSuperview()
        layoutIfNeeded()
        delegate?.didReloadContent(self)
    }
}
