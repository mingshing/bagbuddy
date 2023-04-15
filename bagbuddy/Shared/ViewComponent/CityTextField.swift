//
//  CityTextField.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation
import UIKit

protocol CityInputViewDelegate: UITextFieldDelegate {
    func textFieldDidChangeText(_ textField: CityInputView, text: String?)
    func textFieldDidClearText(_ textField: CityInputView)
    func textFieldDidTapExpand(_ textField: CityInputView)
}

class CityInputView: UIView {
    
    enum LeftViewState {
        case none
        case selected
    }
    
    weak var delegate: CityInputViewDelegate? {
        didSet { inputField.delegate = delegate }
    }
    
    public var leftViewState: LeftViewState = .none {
        didSet {
            switch leftViewState {
            case .selected:
                locationIconImageView.image = UIImage(named: "locationIcon")
            case .none:
                locationIconImageView.image = UIImage(named: "locationDisableIcon")
            }
        }
    }
    
    // MARK - View
    
    private lazy var locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "locationDisableIcon")
        imageView.frame = CGRect(x: 0, y: 0, width: LayoutConstants.smallIconSize + 14, height: LayoutConstants.smallIconSize)
        imageView.image = image
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "expandIcon"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: LayoutConstants.smallIconSize + 14, height: LayoutConstants.smallIconSize)
        button.addTarget(self, action: #selector(pressExpandButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var inputField: UITextField = {
        let textField = UITextField()
        textField.textColor = .primaryWhite
        textField.backgroundColor = .inputBackground
        textField.tintColor = .interactionPrimary
        textField.textColor = .primaryBlack
        textField.font = UIFont.actionTextFont(ofSize: 16)
        
        textField.rightView = expandButton
        textField.rightViewMode = .always
        textField.placeholder = NSLocalizedString("location_input_placeholder", comment: "")
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Private
    private func setup() {
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .inputBackground
        addSubview(locationIconImageView)
        locationIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(LayoutConstants.smallIconSize)
            make.centerY.equalToSuperview()
        }
        
        addSubview(inputField)
        inputField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(14)
            make.left.equalTo(locationIconImageView.snp.right).offset(14)
        }
        layer.cornerRadius = 8
    }
    
    private func refresh() {
        guard let text = inputField.text,
              !text.isEmpty else {
            leftViewState = .none
            return
        }
        leftViewState = .selected
    }
    
    @objc func pressExpandButton(_ sender: Any) {
        delegate?.textFieldDidTapExpand(self)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldDidChangeText(self, text: inputField.text)
    }
}
