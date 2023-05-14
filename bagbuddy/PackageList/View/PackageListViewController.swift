//
//  PackageListViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import SnapKit
import UIKit

enum PackageListSection: Int {
    case customizeTrip = 0
    case startPacking = 1
    case itemList = 2
}


class PackageListViewController: UIViewController {
    
// MARK: View Related
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = { [weak self] in
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .mainHeaderBackground
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.allowsMultipleSelection = true
        table.register(
            PackageItemCell.self,
            forCellReuseIdentifier: String(describing: PackageItemCell.self)
        )
        table.register(
            TagListCell.self,
            forCellReuseIdentifier: String(describing: TagListCell.self)
        )
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var headerView: TripHeaderView = {
        let view = TripHeaderView()
        return view
    }()
    
    private lazy var categorySectionView = SectionHeaderView()
    private lazy var packItemSectionView = SectionHeaderView()

// MARK: Property
    private var presenter: PackageListPresenterType?
    
    init(with viewModel: PackageListViewModel) {
        super.init(nibName: nil, bundle: nil)
        presenter = PackageListPresenter(with: viewModel, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.setupContent()
    }
    
    private func setupView() {
        view.backgroundColor = .mainHeaderBackground
        view.addSubview(tableView)
        view.addSubview(closeButton)
        tableView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(LayoutConstants.actionButtonHeight)
            make.left.equalToSuperview().inset(4)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        presenter?.setupHeader()
        
    }
    @objc func didTapClose(sender: UIButton!) {
        dismiss(animated: true)
    }
}

extension PackageListViewController: PackageListPresenterDelegate {
    
    func updateHeaderView(with viewModel: PackageListViewModel) {
        headerView.updateView(with: viewModel)
        let headerHeight = headerView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0)).height

        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight)
        tableView.tableHeaderView = headerView
    }
    
    func updateContent(with viewModel: PackageListViewModel) {
        categorySectionView.updateView(with: viewModel.categorySection)
        packItemSectionView.updateView(with: viewModel.packItemSection)
        tableView.reloadData()
    }
}



extension PackageListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems(for: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == PackageListSection.customizeTrip.rawValue {
            return categorySectionView
        } else if section == PackageListSection.startPacking.rawValue {
            return packItemSectionView
        } else if section < presenter!.numberOfSections() {
            
            if let itemSectionVC = presenter!.viewModelForItemSection(at: section) {
                let headerView = ItemSectionHeaderView(with: itemSectionVC)
                return headerView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellViewModel = presenter?.viewModelForIndex(at: indexPath) else { return UITableViewCell() }
        
        if cellViewModel is TagListCellViewModel {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TagListCell.self),
                for: indexPath
            ) as! TagListCell
            cell.delegate = self
            return cell
        }
        
        if cellViewModel is PackageItemCellViewModel {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PackageItemCell.self),
                for: indexPath
            ) as! PackageItemCell
            cell.update(with: cellViewModel as! PackageItemCellViewModel)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var cellViewModel = presenter?.viewModelForIndex(at: indexPath) else { return }
        
        if cellViewModel is PackageItemCellViewModel {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.isSelected.toggle()
            }
        }
    }
     */
}

extension PackageListViewController: TagListCellDelegate {
    func listContentChanged() {
        tableView.reloadData()
    }
}

extension PackageListViewController: PackageItemCellDelegate {
    func didTapActionButton(_ viewModel: PackageItemCellViewModel) {
        BagbuddyCoordinator.openNoteEditPage(from: self)
    }
}
