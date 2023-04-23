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
        let packageListVC = PackageListViewController()
        packageListVC.modalPresentationStyle = .fullScreen
        
        sourceVC.present(packageListVC, animated: true, completion: nil)
    }
}
