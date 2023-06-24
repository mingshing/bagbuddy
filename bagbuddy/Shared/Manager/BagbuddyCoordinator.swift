//
//  BagbuddyCoordinator.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation
import FittedSheets

class BagbuddyCoordinator {
    
    static var bottomSheetContainer: SheetViewController?
    
    static func openLocationListPage(
        from sourceVC: UIViewController,
        target: SelectTargetLocation,
        selectedCity: City? = nil,
        locationSelectedBlock: SelectCompletedBlock = nil
    ) {
        let locationListVC = LocationListViewController(
            target: target,
            selectedCity: selectedCity,
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
    
    static func openDatePicker(from sourceVC: SelectDateViewController) {
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = sourceVC
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
    
    static func openNoteEditPage(from sourceVC: PackageListViewController, with viewModel: ItemNoteViewModel) {
        let itemNoteViewController = ItemNoteViewController(with: viewModel, delegate: sourceVC)
        let options = SheetOptions(
                presentingViewCornerRadius: 16,
                setIntrinsicHeightOnNavigationControllers: false,
                useFullScreenMode: false
            )
        let sheetController = SheetViewController(controller: itemNoteViewController, options: options)
        sourceVC.present(sheetController, animated: false)
        bottomSheetContainer = sheetController
    }
    
    // MARK: package list view model builder
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

        var activities: [Activity] = []
        
         if let allCityActivities = LocalDataManager().getActivityItemDomainModel() {
             activities = allCityActivities[destination.name.lowercased()] ?? []
            //activities = Array(cityActivities.values.joined())
        }
        
        return PackageListViewModel(
            tripDestination: destination.displayName,
            startDate: "May 16",
            endDate: "Mar 21",
            categorySection: categorySectionViewModel,
            packItemSection: packItemSectionViewModel,
            activyListSection: ActivityListViewModel(activities: activities),
            activitiesSections: generateDefaultSectionViewModels(activities)
        )
    }
    private static func generateDefaultSectionViewModels(_ activities: [Activity]) -> [ActivitySectionViewModel] {
        
        var sectionViewModels: [ActivitySectionViewModel] = []
        //var sectionViewModels = activities.map { activity in
        //    ActivitySectionViewModel(activity: activity)
        //}
        
        sectionViewModels.insert(
            ActivitySectionViewModel(
                activity: LocalDataManager.shared.getDefaultEssential()
            ),
            at: 0
        )
        if let source = TripPacker.shared.currentPlannedTrip?.source,
           let dest = TripPacker.shared.currentPlannedTrip?.destination {
           
            if source.country.lowercased() != dest.country.lowercased() {
                sectionViewModels.insert(
                    ActivitySectionViewModel(
                        activity: LocalDataManager.shared.getDefaultInternalTrip()
                    ),
                    at: 1
                )
            }
        }
        return sectionViewModels
    }
}
