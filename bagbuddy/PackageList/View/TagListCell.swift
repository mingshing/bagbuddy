//
//  TagListCell.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/29.
//

import UIKit

class TagListCell: UITableViewCell {
    
    private lazy var tagListView = TagListView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
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
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func setupContent() {
        
        tagListView.delegate = self
        tagListView.textFont = .systemFont(ofSize: 15)
        tagListView.shadowRadius = 2
        tagListView.shadowOpacity = 0.4
        tagListView.shadowColor = UIColor.black
        tagListView.shadowOffset = CGSize(width: 1, height: 1)
        tagListView.addTag("Inboard")
        tagListView.addTag("Pomotodo")
        tagListView.addTag("Halo Word")
    }
}

extension TagListCell: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}
