//
//  PackageListViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import SnapKit
import UIKit

class PackageListViewController: UIViewController {
    
// MARK: View Related
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .mainHeaderBackground
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var headerView: TripHeaderView = {
        let view = TripHeaderView(delegate: self)
        
        return view
    }()

// MARK: Property
    private var presenter: PackageListPresenterType?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = PackageListPresenter(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter?.fetchData()
    }
    
    private func setupView() {
        self.view.backgroundColor = .mainHeaderBackground
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}

extension PackageListViewController: PackageListPresenterDelegate {
    func update(with viewModel: PackageListViewModel?) {
        guard let viewModel  = viewModel else { return }
        
        headerView.updateView(with: viewModel)
    }
}

extension PackageListViewController: TripHeaderViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
}
