//
//  SelectDateViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation
import SnapKit
import UIKit

class SelectDateViewController: UIViewController {

    var presenter: SelectDatePresenterType?
    
    //MARK: view related
    private lazy var headLineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.projectFont(ofSize: 20, weight: .bold)
        label.textColor = .primaryBlack
        label.text = NSLocalizedString("third_step_headline", comment: "")

        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "set_time")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.projectFont(ofSize: 20, weight: .bold)
        label.textColor = .primaryBlack
        label.text = NSLocalizedString("third_step_title", comment: "")
        return label
    }()
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.actionTextFont(ofSize: 16)
        label.text = NSLocalizedString("third_step_description", comment: "")
        label.sizeToFit()
        return label
    }()
    
    private lazy var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("third_step_action", comment: ""), for: .normal)
        button.setTitleColor(.interactionDisableText, for: .disabled)
        button.setTitleColor(.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.actionTextFont(ofSize: 16)
        button.backgroundColor = .interactionDisableBackground
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = SelectDatePresenter()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        actionBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-35)
        }
        
        view.addSubview(headLineLabel)
        headLineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mainImageView.snp.top).offset(-32)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.leading.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
        }
        
        view.addSubview(actionBtn)
        actionBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.height.equalTo(LayoutConstants.actionButtonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-66)
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        presenter?.openTripMainPage()
   }
}