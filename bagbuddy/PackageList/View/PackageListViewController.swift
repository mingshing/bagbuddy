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
        scrollView.backgroundColor = .white
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
    
    private lazy var categorySectionView = SectionHeaderView()
    private lazy var packItemSectionView = SectionHeaderView()

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
        scrollView.addSubview(categorySectionView)
        scrollView.addSubview(packItemSectionView)
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        categorySectionView.snp.makeConstraints { make in
            make.left.right.equalTo(headerView)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        packItemSectionView.snp.makeConstraints { make in
            make.left.right.equalTo(headerView)
            make.top.equalTo(categorySectionView.snp.bottom)
        }
    }
    
}

extension PackageListViewController: PackageListPresenterDelegate {
    func update(with viewModel: PackageListViewModel?) {
        guard let viewModel  = viewModel else { return }
        
        headerView.updateView(with: viewModel)
        categorySectionView.updateView(with: viewModel.categorySection)
        packItemSectionView.updateView(with: viewModel.packItemSection)
    }
}

extension PackageListViewController: TripHeaderViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true)
    }
}
