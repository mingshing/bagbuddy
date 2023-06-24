//
//  PackageItemCell.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/25.
//

import UIKit

protocol PackageItemCellDelegate: AnyObject {
    func didTapActionButton()
}


class PackageItemCell: UITableViewCell {
    
    private let stateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "check")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .actionTextFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .primaryBlack
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .actionTextFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .primaryGrey
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "add")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var delegate: PackageItemCellDelegate?
    
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
        contentView.backgroundColor = .white
        contentView.addSubview(stateIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(noteLabel)
        contentView.addSubview(actionButton)
        
        stateIcon.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(LayoutConstants.actionIconWidth)
            make.height.equalTo(LayoutConstants.actionIconHeight)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.equalTo(LayoutConstants.actionIconWidth)
            make.height.equalTo(LayoutConstants.actionIconHeight)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(stateIcon.snp.right)
            make.right.equalTo(actionButton.snp.left)
            make.top.equalToSuperview().inset(12)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            stateIcon.image = UIImage(named: "check_selected")
            nameLabel.attributedText = getStrikethroughText(nameLabel.text)
            noteLabel.textColor = .selectedNoteGrey
            actionButton.setImage(UIImage(named:"add_selected"), for: .normal)
        } else {
            stateIcon.image = UIImage(named: "check")
            nameLabel.attributedText = getNormalText(nameLabel.text)
            noteLabel.textColor = .primaryGrey
            actionButton.setImage(UIImage(named:"add"), for: .normal)
        }
    }
    
    public func update(with viewModel: PackageItemCellViewModel) {
        nameLabel.text = viewModel.name
        noteLabel.text = viewModel.note
    }
    
    private func getStrikethroughText(_ text: String?) -> NSAttributedString? {
        guard let text = text else { return nil }
        let attributedStringWithColor = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strikethroughColor: UIColor.selectedGrey
        ])

        return attributedStringWithColor
    }
    
    private func getNormalText(_ text: String?) -> NSAttributedString? {
        guard let text = text else { return nil }
        let attributedString = NSAttributedString(string: text)

        return attributedString
    }
    
    @objc func buttonAction(sender: UIButton!) {
        delegate?.didTapActionButton()
    }
}
