//
//  ItemNoteViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/6/17.
//

import Foundation
import SnapKit
import UIKit


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
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = ItemNotePresenter(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            make.height.equalTo(60)
        }
        view.layoutIfNeeded()
    }
    @objc func buttonAction(sender: UIButton!) {
        presenter?.saveNote(text: "")
    }
    
}

extension ItemNoteViewController: ItemNotePresenterDelegate {
    func updateNote(text: String) {
        
    }
}

extension ItemNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Measure the new height of the content
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let estimateHeight = max(estimatedSize.height, 60)
        // Update the height of the text view
        inputTextView.snp.updateConstraints { make in
            make.top.equalTo(actionBtn.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(estimateHeight)
        }

        // Tell the form sheet to re-layout its subviews
        view.layoutIfNeeded()
    }
}
