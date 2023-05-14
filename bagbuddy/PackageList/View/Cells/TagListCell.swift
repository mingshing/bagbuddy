//
//  TagListCell.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/29.
//

import UIKit

protocol TagListCellDelegate: AnyObject {
    func listContentChanged()
}


class TagListCell: UITableViewCell {
    
    weak var delegate: TagListCellDelegate?
    private lazy var tagListView = TagListView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        setupView()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(tagListView)
        tagListView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        tagListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
    }
    
    private func setupContent() {
        
        tagListView.delegate = self
        tagListView.addTag("Temple or shrine")
        tagListView.addTag("Shopping")
        tagListView.addTag("Cherry blossom viewing")
        tagListView.addTag("Nightlife")
        tagListView.addTag("Historic landmark")
        tagListView.addTag("Museum")
        tagListView.addTag("Concert")
        tagListView.addTag("Hot spring")
        tagListView.addTag("Hiking")
    }
}

extension TagListCell: TagListViewDelegate {
    func viewReArranged() {
        delegate?.listContentChanged()
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
}
