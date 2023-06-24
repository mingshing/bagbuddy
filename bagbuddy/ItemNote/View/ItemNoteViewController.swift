//
//  ItemNoteViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/6/17.
//

import Foundation
import SnapKit
import UIKit

protocol ItemNoteDelegate: AnyObject {
    
    func updateSaveNote(note: String?)
}

class ItemNoteViewController: UIViewController {

    var presenter: ItemNotePresenterType?
    
    //MARK: view related
    private lazy var headLineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.actionTextFont(ofSize: 14, weight: .semibold)
        label.textColor = .primaryBlack
        label.text = "Head line"
        return label
    }()
    
    private lazy var inputTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .inputBackground
        view.textColor = .primaryBlack
        view.tintColor = .primaryBlack
        view.textContainerInset = UIEdgeInsets(
            top: LayoutConstants.verticalMargin,
            left: LayoutConstants.horizontalMargin,
            bottom: LayoutConstants.verticalMargin,
            right: LayoutConstants.horizontalMargin
        )
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        view.font = UIFont.actionTextFont(ofSize: 14)
        view.isScrollEnabled = false
        view.delegate = self
        return view
    }()
    
    
    private lazy var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("general_done", comment:""), for: .normal)
        
        button.setTitleColor(.mainItemOrange, for: .normal)
        button.titleLabel?.font = UIFont.actionTextFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    weak private var delegate: ItemNoteDelegate?
    private var viewModel: ItemNoteViewModel
    init(with viewModel: ItemNoteViewModel, delegate: ItemNoteDelegate?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupView()
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(headLineLabel)
        view.addSubview(actionBtn)
        view.addSubview(inputTextView)
        actionBtn.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.actionButtonHeight)
            make.top.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
        }
        
        headLineLabel.snp.makeConstraints { make in
            make.centerY.equalTo(actionBtn)
            make.width.equalTo(278)
            make.left.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.top.equalTo(actionBtn.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(64)
        }
        view.layoutIfNeeded()
    }
    
    private func setupContent() {
        headLineLabel.text = viewModel.name
        if let note = viewModel.note {
            inputTextView.text = note
        } else {
            inputTextView.text = NSLocalizedString("item_note_placeholder", comment:"")
            inputTextView.textColor = .selectedNoteGrey
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if !inputTextView.text.isEmpty {
            self.delegate?.updateSaveNote(note: inputTextView.text)
        }
        self.dismiss(animated: true)
    }
}


extension ItemNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Measure the new height of the content
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let estimateHeight = max(estimatedSize.height, 64)
        // Update the height of the text view
        inputTextView.snp.updateConstraints { make in
            make.top.equalTo(actionBtn.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(estimateHeight)
        }
        view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if viewModel.note == nil {
            inputTextView.text = ""
            inputTextView.textColor = .primaryBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            inputTextView.text = NSLocalizedString("item_note_placeholder", comment:"")
            inputTextView.textColor = .selectedNoteGrey
        }
    }
    
}
