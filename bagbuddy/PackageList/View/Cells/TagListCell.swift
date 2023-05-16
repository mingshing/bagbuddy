//
//  TagListCell.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/29.
//

import UIKit

protocol TagListCellDelegate: AnyObject {
    func listContentChanged()
    func addActivity(_ title: String)
    func removeActivity(_ title: String)
}


class TagListCell: UITableViewCell {
    
    weak var delegate: TagListCellDelegate?
    private lazy var tagListView = TagListView()
    
    init(reuseIdentifier: String, tags: [String]?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        setupView()
        setupContent(tags: tags)
        tagListView.delegate = self
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    private func setupContent(tags: [String]?) {
        guard let tags = tags else { return }
        tagListView.addTags(tags)
    }
}

extension TagListCell: TagListViewDelegate {
    func viewReArranged() {
        //delegate?.listContentChanged()
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if tagView.isSelected {
            delegate?.addActivity(title)
        } else {
            delegate?.removeActivity(title)
        }
    }
}
