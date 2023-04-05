//
//  BagbuddyCoordinator.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import Foundation
import MessageUI

class BagbuddyCoordinator {
    
    static func openSelectLocationPage(from sourceVC: UIViewController, target: SelectTargetLocation) {
        let locationVC = SelectLocationViewController(target: target)
        guard
            let navigationVC = sourceVC.navigationController
        else {
            sourceVC.show(locationVC, sender: nil)
            return
        }
        navigationVC.pushViewController(locationVC, animated: true)
    }
    
    static func openSelectDatePage(from sourceVC: UIViewController) {
        print("open select date page")
    }
}
