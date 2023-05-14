//
//  TagView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//
import UIKit

@IBDesignable
open class TagView: UIButton {
    
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var titleLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            titleLabel?.lineBreakMode = titleLineBreakMode
        }
    }
    @IBInspectable open var paddingY: CGFloat = 10 {
        didSet {
            contentEdgeInsets.top = paddingY
            contentEdgeInsets.bottom = paddingY
        }
    }
    
    @IBInspectable open var paddingX: CGFloat = 5 {
        didSet {
            titleEdgeInsets.left = paddingX
            titleEdgeInsets.right = paddingX
            imageEdgeInsets.right = paddingX
        }
    }

    @IBInspectable open var tagBackgroundColor: UIColor = .white {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var highlightedBackgroundColor: UIColor = .mainItemOrange {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBorderColor: UIColor = .mainItemOrange {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var selectedBackgroundColor: UIColor = .mainItemOrange {
        didSet {
            reloadStyles()
        }
    }
    
    @IBInspectable open var textFont: UIFont = .actionTextFont(ofSize: 14) {
        didSet {
            titleLabel?.font = textFont
        }
    }
    
    private func reloadStyles() {
        if isHighlighted {
            backgroundColor = highlightedBackgroundColor
        }
        else if isSelected {
            backgroundColor = selectedBackgroundColor
            layer.borderColor = selectedBorderColor.cgColor
            setTitleColor(selectedTextColor, for: UIControl.State())
        }
        else {
            backgroundColor = tagBackgroundColor
            layer.borderColor = borderColor?.cgColor
            setTitleColor(textColor, for: UIControl.State())
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    
    /// Handles Tap (TouchUpInside)
    open var onTap: ((TagView) -> Void)?
    open var onLongPress: ((TagView) -> Void)?
    open var iconImageSize: CGFloat
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        iconImageSize = 12
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(title: String, iconImageSize: CGFloat = 12) {
        self.iconImageSize = iconImageSize
        super.init(frame: CGRect.zero)
        setTitle(title, for: UIControl.State())
        
        setupView()
    }
    
    private func setupView() {
        titleLabel?.lineBreakMode = titleLineBreakMode

        frame.size = intrinsicContentSize
        setImage(UIImage(named: "tagPlus"), for: .normal)
        setImage(UIImage(named: "tagCheck"), for: .selected)
        
        titleEdgeInsets.left = paddingX + iconImageSize
    }
    
    
    // MARK: - layout
    
    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: textFont]) ?? CGSize.zero
        size.height += 2 * 8
        size.width += (iconImageSize + 3 * paddingX)
        
        return size
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
   
}
