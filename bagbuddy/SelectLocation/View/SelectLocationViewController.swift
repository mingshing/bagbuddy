//
//  FirstStepViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation
import SnapKit
import UIKit

enum SelectTargetLocation: String {
    case source = "Current location"
    case destination = "Destination"
}

class SelectLocationViewController: UIViewController {

    var presenter: SelectLocationPresenterType?
    
    //MARK: view related
    private lazy var headLineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.projectFont(ofSize: 20, weight: .bold)
        label.textColor = .primaryBlack
        switch selectTarget {
        case .source:
            label.text = NSLocalizedString("first_step_headline", comment: "")
        case .destination:
            label.text = NSLocalizedString("second_step_headline", comment: "")
        }
        
        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        switch selectTarget {
        case .source:
            imageView.image = UIImage(named: "set_location")
        case .destination:
            imageView.image = UIImage(named: "set_destination")
        }
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.projectFont(ofSize: 20, weight: .bold)
        label.textColor = .primaryBlack
        switch selectTarget {
        case .source:
            label.text = NSLocalizedString("first_step_title", comment: "")
        case .destination:
            label.text = NSLocalizedString("second_step_title", comment: "")
        }
        return label
    }()
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.actionTextFont(ofSize: 16)
        switch selectTarget {
        case .source:
            label.text = NSLocalizedString("first_step_description", comment: "")
        case .destination:
            label.text = NSLocalizedString("second_step_description", comment: "")
        }
        label.sizeToFit()
        return label
    }()
    
    private lazy var locationInputView: CityInputView = {
        let textInputView = CityInputView()
        textInputView.delegate = self
        
        return textInputView
    }()
    
    private lazy var actionBtn: UIButton = {
        let button = UIButton()
        switch selectTarget {
        case .source:
            button.setTitle(NSLocalizedString("first_step_action", comment: ""), for: .normal)
        case .destination:
            button.setTitle(NSLocalizedString("second_step_action", comment: ""), for: .normal)
        }
        button.setTitleColor(.interactionDisableText, for: .disabled)
        button.setTitleColor(.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.actionTextFont(ofSize: 16)
        button.backgroundColor = .interactionDisableBackground
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let selectTarget: SelectTargetLocation
    
    init(target: SelectTargetLocation = .source) {
        selectTarget = target
        super.init(nibName: nil, bundle: nil)
        presenter = SelectLocationPresenter(delegate: self)
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
        
        view.addSubview(locationInputView)
        locationInputView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.height.equalTo(LayoutConstants.inputFieldHeight)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(28)
        }
        
        view.addSubview(actionBtn)
        actionBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.height.equalTo(LayoutConstants.actionButtonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-66)
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        presenter?.nextStep()
    }
    
}

extension SelectLocationViewController: SelectLocationDelegate {

    func enterNextStep() {
        switch selectTarget {
        case .source:
            BagbuddyCoordinator.openSelectLocationPage(from: self, target: .destination)
        case .destination:
            BagbuddyCoordinator.openSelectDatePage(from: self)
        }
    }
    
    func showLocationListPage() {
        
        BagbuddyCoordinator.openLocationListPage(
            from: self,
            target: selectTarget) { [weak self] selectedCityName in
                guard let cityName = selectedCityName,
                      !cityName.isEmpty else {
                    self?.locationInputView.leftViewState = .none
                    self?.locationInputView.inputField.text = ""
                    return
                }
                self?.locationInputView.leftViewState = .selected
                self?.locationInputView.inputField.text = cityName
            }
    }
    
}

extension SelectLocationViewController: CityInputViewDelegate {
    
    func textFieldDidChangeText(_ textField: CityInputView, text: String?) {}
    
    func textFieldDidClearText(_ textField: CityInputView) {}
    
    func textFieldDidTapExpand(_ textField: CityInputView) {
        presenter?.openSelectCityPage()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        presenter?.openSelectCityPage()
    }
}
