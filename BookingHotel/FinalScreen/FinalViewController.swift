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

        // Закругляем кнопку Super!
        UtilityManager.shared.cornerRadius(for: superButton, radius: 15)

        // Задаем бордер для нижнего вью
        UtilityManager.shared.configureBordersForBottomView(view: bottomViewWithButton)
        
        // Делаем круг из вью с поздравительным изображением
        viewWithImage.layer.cornerRadius = viewWithImage.frame.size.width / 2
        
        // Текст для подтверждения заказа
        orderConfirmation.text = UtilityManager.shared.orderConfirmation()
    }

    // Возвращаеся на стартовый экран
    @IBAction func superButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
