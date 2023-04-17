//
//  DateField.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import UIKit

protocol DateInputViewDelegate: UITextFieldDelegate {

    func dateFieldDidTapExpand(_ dateField: DateInputView)
}

class DateInputView: UIView {
    
    // MARK - View
    
    weak var delegate: DateInputViewDelegate? {
        didSet { inputField.delegate = delegate }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.actionTextFont(ofSize: 16)
        label.textColor = .disableText

        return label
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
        textField.backgroundColor = .inputBackground
        textField.tintColor = .interactionPrimaryBackground
        textField.textColor = .primaryBlack
        textField.font = UIFont.actionTextFont(ofSize: 16)
        
        textField.rightView = expandButton
        textField.rightViewMode = .always
        textField.placeholder = NSLocalizedString("date_input_placeholder", comment: "")
        
        return textField
    }()
    
    var titlePlaceholder: String
    
    init (
        titlePlaceHolder: String,
        delegate: DateInputViewDelegate? = nil
    ) {
        self.titlePlaceholder = titlePlaceHolder
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupView() {
        backgroundColor = .inputBackground
        addSubview(titleLabel)
        titleLabel.text = titlePlaceholder
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        addSubview(inputField)
        inputField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(14)
            make.left.equalToSuperview().offset(80)
        }
        layer.cornerRadius = 8
    }
    
    @objc func pressExpandButton(_ sender: Any) {
        delegate?.dateFieldDidTapExpand(self)
    }
}
