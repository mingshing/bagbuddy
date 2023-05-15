//
//  ItemSectionHeaderView.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/29.
//

import UIKit

enum ItemSectionState {
    case close
    case open
}

protocol ItemSectionHeaderViewDelegate: AnyObject {
    func didTapActivity(_ view: ItemSectionHeaderView, currentState: ItemSectionState)
}

class ItemSectionHeaderView: UIView {
    
    private lazy var indicator: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "dropdownIcon")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.actionTextFont(ofSize: 14)
        label.textColor = .primaryBlack
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = UIFont.actionTextFont(ofSize: 12)
        label.textColor = .primaryGrey
        return label
    }()
    
    private var sectionState: ItemSectionState = .close {
        didSet {
            switch sectionState {
            case .close:
                indicator.image = UIImage(named: "dropdownIcon")
            case .open:
                indicator.image = UIImage(named: "expandIcon")
            }
        }
    }
    private let viewModel: ActivitySectionViewModel
    
    var delegate: ItemSectionHeaderViewDelegate?
    
    init(with viewModel: ActivitySectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupContent(with: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.size.equalTo(LayoutConstants.smallIconSize)
            make.left.equalToSuperview().inset(20)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(indicator.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(12)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    public func setupContent(with viewModel: ActivitySectionViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = String(format: NSLocalizedString("package_tag_count", comment: ""),viewModel.itemCount)
        sectionState = viewModel.displayState
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapActivity(self, currentState: viewModel.displayState)
    }
}
