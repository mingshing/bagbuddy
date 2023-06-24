//
//  OnboardingViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/2.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var actionBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        actionBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        actionBtn.layer.cornerRadius = 8.0
        actionBtn.backgroundColor = .interactionPrimaryBackground
        actionBtn.setTitleColor(.primaryBlack, for: .normal)
        actionBtn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        actionBtn.layoutIfNeeded()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        TripPacker.shared.startNewTrip()
        //BagbuddyCoordinator.openSelectLocationPage(from: self, target: .source)
        BagbuddyCoordinator.openPackageListPage(from: self)
   }
}

