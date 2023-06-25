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


class PackageListViewController: UIViewController, ItemNoteDelegate {
    
// MARK: View Related
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = LayoutConstants.actionButtonHeight / 2.0
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = { [weak self] in
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .mainHeaderBackground
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.estimatedRowHeight = 48
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
    
    private var tagListHeight: CGFloat {
        
        let tagListView = TagListView(frame: CGRectMake(0, 0, DeviceConstants.width - 2*LayoutConstants.pageHorizontalMargin, 0))
        tagListView.addTags(presenter?.viewModel.activyListSection.activityNames ?? [])
        
        return tagListView.intrinsicContentSize.height + 20
    }

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
    
    func updateActivitiesSection(section: Int) {
        reloadSection(section: section)
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
        if indexPath.section == PackageListSection.customizeTrip.rawValue {
            return tagListHeight
        }
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
                headerView.delegate = self
                headerView.tag = section
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
        
        if let tagListCellViewModel = cellViewModel as? TagListCellViewModel {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TagListCell.self),
                for: indexPath
            ) as! TagListCell
            cell.tags = tagListCellViewModel.tags
            if let selectedActivityTitle = presenter?.viewModel.selectedActivityTitle {
                cell.updateSelectedTag(selectedTags: selectedActivityTitle)
            }
            cell.delegate = self
            return cell
        }
        
        if let itemCellViewModel = cellViewModel as? PackageItemCellViewModel {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PackageItemCell.self),
                for: indexPath
            ) as! PackageItemCell
            cell.delegate = self
            cell.update(with: itemCellViewModel)
            //cell.isSelected = itemCellViewModel.checked
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = presenter?.viewModelForIndex(at: indexPath) else { return }
        
        if cellViewModel is PackageItemCellViewModel,
           var itemCellViewModel = presenter?.viewModelForIndex(at: indexPath) as? PackageItemCellViewModel {
            itemCellViewModel.checked = true
            presenter?.updateItemViewModelForIndex(itemCellViewModel, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cellViewModel = presenter?.viewModelForIndex(at: indexPath) else { return }
        
        if cellViewModel is PackageItemCellViewModel,
           var itemCellViewModel = presenter?.viewModelForIndex(at: indexPath) as? PackageItemCellViewModel {
            itemCellViewModel.checked = false
            presenter?.updateItemViewModelForIndex(itemCellViewModel, at: indexPath)
        }
    }
     
}

extension PackageListViewController: TagListCellDelegate {
    
    func listContentChanged(_ selectedTitle: [String]) {
        presenter?.viewModel.selectedActivityTitle = selectedTitle
    }
    
    func addActivity(_ title: String) {
        // TODO: if add new activity while the last section is open, it would crash
        if let activityList = self.presenter?.viewModel.activyListSection.activities,
           let addedActivity = activityList.filter({ activity in
               activity.name == title
           }).first {
            let newSectionModel = ActivitySectionViewModel(
                activity: addedActivity
            )
            presenter?.viewModel.activitiesSections.append(newSectionModel)
            let insertIdx = self.presenter?.viewModel.activitiesSections.count ?? 0 - 1
            tableView.beginUpdates()
            tableView.insertSections(IndexSet(integer: insertIdx), with: .bottom)
            tableView.endUpdates()
            presenter?.viewModel.addNewActivityItemModels(from: newSectionModel)
            DispatchQueue.main.async { [weak self] in
                
                self?.reloadSection(section: insertIdx + 1)
            }
        }
    }
    
    func removeActivity(_ title: String) {
        
        let removeIdx = presenter?.removeItemSection(with: title)
        guard let removeIdx = removeIdx,
              removeIdx >= 0 else { return }
        
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(integer: removeIdx), with: .fade)
        tableView.endUpdates()
        
    }
    
    func reloadCell(row: Int, section: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
    }
    
    func reloadSection(section: Int) {
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        if let viewModel = presenter?.viewModel {
            for (section, sectionItemViewModels) in viewModel.itemViewModels.enumerated() {
                for (row, itemViewModel) in sectionItemViewModels.enumerated() {
                    let displaySection = section + PackageListSection.itemList.rawValue
                    if itemViewModel.checked {
                        tableView.selectRow(at: IndexPath(row: row, section: displaySection), animated: false, scrollPosition: .none)
                    }
                }
            }
        }
        /*
        if let selectedIndexPaths = selectedIndexPaths {
            for indexPath in selectedIndexPaths {
                
            }
        }
        */
    }
    
}

extension PackageListViewController: PackageItemCellDelegate {
    
    func didTapActionButton(_ cell: UITableViewCell, on viewModel: PackageItemCellViewModel) {
        if let indexPath = tableView.indexPath(for: cell) {
            let itemNoteViewModel = ItemNoteViewModel(
                name: viewModel.name,
                for: indexPath,
                note: viewModel.note
            )
            BagbuddyCoordinator.openNoteEditPage(from: self, with: itemNoteViewModel)
        }
    }
}

extension PackageListViewController {
    func updateSaveNote(from viewModel: ItemNoteViewModel) {
        if var itemCellViewModel = presenter?.viewModelForIndex(at: viewModel.indexPath) as? PackageItemCellViewModel {
            itemCellViewModel.note = viewModel.note
            presenter?.updateItemViewModelForIndex(itemCellViewModel, at: viewModel.indexPath)
            tableView.reloadRows(at: [viewModel.indexPath], with: .fade)
        }
    }
}

extension PackageListViewController: ItemSectionHeaderViewDelegate {
    func didTapActivity(_ view: ItemSectionHeaderView, currentState: ItemSectionState) {
        presenter?.changeItemSectionState(section: view.tag, fromState: currentState)
    }
}
