//
//  TagListView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//
import UIKit

@objc public protocol TagListViewDelegate {
    @objc optional func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    @objc func viewReArranged() -> Void
}

@objc public enum Alignment: Int {
    case left
    case center
    case right
    case leading
    case trailing
}

@IBDesignable
open class TagListView: UIView {
    
    @IBInspectable open dynamic var textColor: UIColor = .mainItemOrange {
        didSet {
            tagViews.forEach {
                $0.textColor = textColor
            }
        }
    }
    
    @IBInspectable open dynamic var selectedTextColor: UIColor = .white {
        didSet {
            tagViews.forEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }

    @IBInspectable open dynamic var tagLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            tagViews.forEach {
                $0.titleLineBreakMode = tagLineBreakMode
            }
        }
    }
    
    @IBInspectable open dynamic var tagBackgroundColor: UIColor = UIColor.white {
        didSet {
            tagViews.forEach {
                $0.tagBackgroundColor = tagBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var tagHighlightedBackgroundColor: UIColor = .white {
        didSet {
            tagViews.forEach {
                $0.highlightedBackgroundColor = tagHighlightedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var tagSelectedBackgroundColor: UIColor = .mainItemOrange {
        didSet {
            tagViews.forEach {
                $0.selectedBackgroundColor = tagSelectedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var borderColor: UIColor = .mainItemOrange {
        didSet {
            tagViews.forEach {
                $0.layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    @IBInspectable open dynamic var borderWidth: CGFloat = 1 {
        didSet {
            tagViews.forEach {
                $0.layer.borderWidth = borderWidth
            }
        }
    }
    
    @IBInspectable open dynamic var selectedBorderColor: UIColor = .mainItemOrange {
        didSet {
            tagViews.forEach {
                $0.selectedBorderColor = selectedBorderColor
            }
        }
    }
    
    @IBInspectable open dynamic var paddingY: CGFloat = 2 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.paddingY = paddingY
            }
        }
    }
    
    @IBInspectable open dynamic var paddingX: CGFloat = 12 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.paddingX = paddingX
            }
        }
    }
    
    @IBInspectable open dynamic var marginY: CGFloat = 8 {
        didSet {
            rearrangeViews()
        }
    }
    
    @IBInspectable open dynamic var marginX: CGFloat = 4 {
        didSet {
            rearrangeViews()
        }
    }

    @IBInspectable open dynamic var minWidth: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    
    @IBInspectable open var alignment: Alignment = .leading {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc open dynamic var textFont: UIFont = .actionTextFont(ofSize: 14) {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.textFont = textFont
            }
        }
    }
    
    @IBOutlet open weak var delegate: TagListViewDelegate?
    
    open private(set) var tagViews: [TagView] = []
    private(set) var tagBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        defer { rearrangeViews() }
        super.layoutSubviews()
    }
    
    private func rearrangeViews() {
        let views = tagViews as [UIView] + tagBackgroundViews + rowViews
        views.forEach {
            $0.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        let frameWidth = frame.width
        
        let directionTransform = CGAffineTransform.identity
        
        for (index, tagView) in tagViews.enumerated() {
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > frameWidth {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.transform = directionTransform
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)

                tagView.frame.size.width = min(tagView.frame.size.width, frameWidth)
            }
            
            let tagBackgroundView = tagBackgroundViews[index]
            tagBackgroundView.transform = directionTransform
            tagBackgroundView.frame.origin = CGPoint(
                x: currentRowWidth,
                y: 0)
            tagBackgroundView.frame.size = tagView.bounds.size
            tagView.frame.size.width = max(minWidth, tagView.frame.size.width)
           
            tagBackgroundView.addSubview(tagView)
            currentRowView.addSubview(tagBackgroundView)
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + marginX
            
            switch alignment {
            case .leading: fallthrough // switch must be exahutive
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frameWidth - (currentRowWidth - marginX)) / 2
            case .trailing: fallthrough // switch must be exahutive
            case .right:
                currentRowView.frame.origin.x = frameWidth - (currentRowWidth - marginX)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
        invalidateIntrinsicContentSize()
        delegate?.viewReArranged()
    }
    
    // MARK: - Manage tags
    
    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        return CGSize(width: frame.width, height: height)
    }
    
    private func createNewTagView(_ title: String) -> TagView {
        let tagView = TagView(title: title)
        
        tagView.textColor = textColor
        tagView.selectedTextColor = selectedTextColor
        tagView.tagBackgroundColor = tagBackgroundColor
        tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
        tagView.selectedBackgroundColor = tagSelectedBackgroundColor
        tagView.titleLineBreakMode = tagLineBreakMode
        tagView.layer.borderWidth = borderWidth
        tagView.borderColor = borderColor
        tagView.selectedBorderColor = selectedBorderColor
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = textFont
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
        
        return tagView
    }

    @discardableResult
    open func addTag(_ title: String) -> TagView {
        defer { rearrangeViews() }
        return addTagView(createNewTagView(title))
    }
    
    @discardableResult
    open func addTags(_ titles: [String]) -> [TagView] {
        return addTagViews(titles.map(createNewTagView))
    }
    
    @discardableResult
    open func addTagView(_ tagView: TagView) -> TagView {
        defer { rearrangeViews() }
        tagViews.append(tagView)
        tagBackgroundViews.append(UIView(frame: tagView.bounds))
        
        return tagView
    }
    
    @discardableResult
    open func addTagViews(_ tagViewList: [TagView]) -> [TagView] {
        defer { rearrangeViews() }
        tagViewList.forEach {
            tagViews.append($0)
            tagBackgroundViews.append(UIView(frame: $0.bounds))
        }
        return tagViews
    }

    @discardableResult
    open func insertTag(_ title: String, at index: Int) -> TagView {
        return insertTagView(createNewTagView(title), at: index)
    }
    

    @discardableResult
    open func insertTagView(_ tagView: TagView, at index: Int) -> TagView {
        defer { rearrangeViews() }
        tagViews.insert(tagView, at: index)
        tagBackgroundViews.insert(UIView(frame: tagView.bounds), at: index)
        
        return tagView
    }
    
    open func setTitle(_ title: String, at index: Int) {
        tagViews[index].titleLabel?.text = title
    }
    
    open func removeTag(_ title: String) {
        tagViews.reversed().filter({ $0.currentTitle == title }).forEach(removeTagView)
    }
    
    open func removeTagView(_ tagView: TagView) {
        defer { rearrangeViews() }
        
        tagView.removeFromSuperview()
        if let index = tagViews.firstIndex(of: tagView) {
            tagViews.remove(at: index)
            tagBackgroundViews.remove(at: index)
        }
    }
    
    open func removeAllTags() {
        defer {
            tagViews = []
            tagBackgroundViews = []
            rearrangeViews()
        }
        
        let views: [UIView] = tagViews + tagBackgroundViews
        views.forEach { $0.removeFromSuperview() }
    }

    open func selectedTags() -> [TagView] {
        return tagViews.filter { $0.isSelected }
    }
    
    // MARK: - Events
    
    @objc func tagPressed(_ sender: TagView!) {
        sender.onTap?(sender)
        delegate?.tagPressed?(sender.currentTitle ?? "", tagView: sender, sender: self)
    }
}
