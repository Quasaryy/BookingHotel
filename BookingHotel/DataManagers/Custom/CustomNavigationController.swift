//
//  CustomNavigationController.swift
//  BookingHotel
//
//  Created by Yury on 14/09/2023.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
}

extension CustomNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard navigationController.viewControllers.count > 1 else {
            viewController.navigationItem.leftBarButtonItem = nil
            return
        }
        
        let backButtonImage = UIImage(named: "right")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewController.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        self.popViewController(animated: true)
    }
    
}
