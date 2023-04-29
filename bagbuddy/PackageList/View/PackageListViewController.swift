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
    private lazy var categoryListView = TagListView()
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
        
        categoryListView.delegate = self
        categoryListView.textFont = .systemFont(ofSize: 15)
        categoryListView.shadowRadius = 2
        categoryListView.shadowOpacity = 0.4
        categoryListView.shadowColor = UIColor.black
        categoryListView.shadowOffset = CGSize(width: 1, height: 1)
        categoryListView.addTag("Inboard")
        categoryListView.addTag("Pomotodo")
        categoryListView.addTag("Halo Word")
        
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
        scrollView.addSubview(categoryListView)
        scrollView.addSubview(packItemSectionView)
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        categorySectionView.snp.makeConstraints { make in
            make.left.right.equalTo(headerView)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        categoryListView.snp.makeConstraints { make in
            make.left.right.equalTo(headerView).inset(20)
            make.top.equalTo(categorySectionView.snp.bottom)
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

extension PackageListViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}
