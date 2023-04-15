//
//  LocationListViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/8.
//

import Foundation
import SnapKit
import UIKit

public typealias SelectCompletedBlock = ((String?) -> Void)?

class LocationListViewController: UIViewController {

    //MARK: view related
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.projectFont(ofSize: 28, weight: .bold)
        label.textColor = .primaryBlack
        return label
    }()
    
    private lazy var locationInputView: CityInputView = {
        let textInputView = CityInputView()
        textInputView.leftViewState = .selected
        textInputView.delegate = self
        
        return textInputView
    }()
    
    private lazy var tableView: UITableView = { [weak self] in
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.register(
            LocationListViewCell.self,
            forCellReuseIdentifier: String(describing: LocationListViewCell.self)
        )
        
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    var presenter: LocationListPresenterType?
    var completetion: SelectCompletedBlock
    var selectedCityName: String? {
        didSet {
            completetion?(selectedCityName)
        }
    }
    
    init(target: SelectTargetLocation,
         completetion: SelectCompletedBlock = nil
    ) {
        
        self.completetion = completetion
        super.init(nibName: nil, bundle: nil)
    
        self.navigationTitleLabel.text = target.rawValue
        self.presenter = LocationListPresenter(delegate: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter?.updateItems(with: nil)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(4)
            make.size.equalTo(48)
        }
        
        view.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
        }
        
        view.addSubview(locationInputView)
        locationInputView.snp.makeConstraints { make in
            make.top.equalTo(navigationTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(locationInputView)
            make.top.equalTo(locationInputView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    @objc func didTapClose(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
   }
}

extension LocationListViewController: LocationListPresenterDelegate {
    func didUpdateViewModel() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }
    }
}

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let presenter = presenter else { return 0 }
        
        return presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellViewModel = presenter?.viewModelForIndex(at: indexPath.row) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: LocationListViewCell.self),
            for: indexPath
        ) as! LocationListViewCell
        cell.update(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = presenter?.viewModelForIndex(at: indexPath.row) else { return }
        
        locationInputView.inputField.text = cellViewModel.locationName
        selectedCityName = cellViewModel.locationName
    }
    
}


extension LocationListViewController: CityInputViewDelegate {
    
    func textFieldDidChangeText(_ textField: CityInputView, text: String?) {
        presenter?.updateItems(with: text)
    }
    
    func textFieldDidClearText(_ textField: CityInputView) {
        presenter?.updateItems(with: nil)
    }
    
    func textFieldDidTapExpand(_ textField: CityInputView) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
