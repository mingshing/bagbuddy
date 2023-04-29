//
//  BagbuddyCoordinator.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation
import MessageUI

class BagbuddyCoordinator {
    
    static func openLocationListPage(
        from sourceVC: UIViewController,
        target: SelectTargetLocation,
        selectedCityName: String? = nil,
        locationSelectedBlock: SelectCompletedBlock = nil
    ) {
        let locationListVC = LocationListViewController(
            target: target,
            selectedCityName: selectedCityName,
            completetion: locationSelectedBlock
        )
        locationListVC.modalPresentationStyle = .pageSheet
        
        sourceVC.present(locationListVC, animated: true, completion: nil)
    }
    
    
    static func openSelectLocationPage(
        from sourceVC: UIViewController,
        target: SelectTargetLocation
    ) {
        let setLocationVC = SelectLocationViewController(target: target)
        guard
            let navigationVC = sourceVC.navigationController
        else {
            sourceVC.show(setLocationVC, sender: nil)
            return
        }
        navigationVC.pushViewController(setLocationVC, animated: true)
    }
    
    static func openSelectDatePage(from sourceVC: UIViewController) {
        let dateVC = SelectDateViewController()
        guard
            let navigationVC = sourceVC.navigationController
        else {
            sourceVC.show(dateVC, sender: nil)
            return
        }
        navigationVC.pushViewController(dateVC, animated: true)
    }
    
    static func openDatePicker(from sourceVC: UIViewController) {
        let datePickerVC = DatePickerViewController()
        datePickerVC.modalPresentationStyle = .pageSheet
        
        sourceVC.present(datePickerVC, animated: true, completion: nil)
    }
    
    static func openPackageListPage(from sourceVC: UIViewController) {
        guard let viewModel = buildPackageListViewModel() else { return }
        let packageListVC = PackageListViewController(with: viewModel)
        packageListVC.modalPresentationStyle = .fullScreen
        packageListVC.modalPresentationCapturesStatusBarAppearance = true
        sourceVC.present(packageListVC, animated: true, completion: nil)
    }
    
    static func buildPackageListViewModel() -> PackageListViewModel? {
        
        guard let destination = TripPacker.shared.currentPlannedTrip?.destination else { return nil }
        let categorySectionViewModel = SectionHeaderViewModel(
            title: "Customize your trip",
            description: "What will you be doing on this trip?"
        )
        
        let packItemSectionViewModel = SectionHeaderViewModel(
            title: "Start packing",
            description: "Your AI generated packing list:"
        )
        
        let essentialSection =
        ItemSectionHeaderViewModel(
            title: "Essentials",
            itemCount: 9
        )
        
        let aboardSection =
        ItemSectionHeaderViewModel(
            title: "International trip",
            itemCount: 7
        )
        return PackageListViewModel(
            tripDestination: destination,
            startDate: "Mar 21",
            endDate: "Mar 23",
            categorySection: categorySectionViewModel,
            packItemSection: packItemSectionViewModel,
            itemsSections: [essentialSection,aboardSection]
        )
    }
}
