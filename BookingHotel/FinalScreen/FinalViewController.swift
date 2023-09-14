//
//  FinalViewController.swift
//  BookingHotel
//
//  Created by Yury on 12/09/2023.
//

import UIKit

class FinalViewController: UIViewController {

    // MARK: - IB Outlets
    
    // Аутлеты для различных UI элементов
    @IBOutlet weak var orderConfirmation: UILabel!
    @IBOutlet weak var bottomViewWithButton: UIView!
    @IBOutlet weak var viewWithImage: UIView!
    @IBOutlet weak var superButton: UIButton!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Первоначальная настройка UI
        UIManager.shared.setupFourthScreenUI(
            superButton: superButton,
            bottomViewWithButton: bottomViewWithButton,
            viewWithImage: viewWithImage,
            orderConfirmation: orderConfirmation
        )
    }
    
    // Возвращаеся на стартовый экран
    @IBAction func superButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
