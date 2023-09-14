//
//  UIManager.swift
//  BookingHotel
//
//  Created by Yury on 14/09/2023.
//

import Foundation
import UIKit

class UIManager {
    
    // MARK: - Propertis
    
    // Синглтон для доступа к менеджеру
    static let shared = UIManager()
    
    // MARK: - Init
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private init() {}
    
}

// MARK: - Methods

extension UIManager {
    
    // MARK: Третий экран
    
    // Закругление вьюх
    func setupViewElements(views: [UIView]) {
        for view in views {
            UtilityManager.shared.cornerRadius(for: view, radius: 15)
        }
    }
    
    // Закругление кнопок в секциях
    func setupButtons(buttons: [UIButton], radius: CGFloat) {
        for button in buttons {
            UtilityManager.shared.cornerRadius(for: button, radius: radius)
        }
    }
    
    // Настройка текстовых полей
    func setupTextFields(textFields: [UITextField], radius: CGFloat) {
        TextFieldManager.shared.textFiledsConfig(for: textFields, radius: radius)
    }
    
    // Настройка стека с оценкой отеля
    func setupStackViewWithStar(stackView: UIStackView) {
        UtilityManager.shared.hotelLevel(stackView: stackView)
    }
    
    // Добавляем бордер к нижней вью с кнопкой
    func setupViewWithBorder(view: UIView) {
        UtilityManager.shared.configureBordersForBottomView(view: view)
    }
    
    // Настройка поведение клавиатуры
    func setupKeyboardHiding(viewController: UIViewController, scrollView: UIScrollView) {
        TextFieldManager.shared.setupGestureToHideKeyboard(viewController: viewController)
        ScrollViewManager.shared.setupToHideKeyboardOnScroll(scrollView: scrollView, viewController: viewController)
    }
    
    // MARK: Четвертый экран
    
    func setupFourthScreenUI(superButton: UIButton, bottomViewWithButton: UIView, viewWithImage: UIView, orderConfirmation: UILabel) {
        
        // Закругляем кнопку Super!
        UtilityManager.shared.cornerRadius(for: superButton, radius: 15)
        
        // Задаем бордер для нижнего вью
        UtilityManager.shared.configureBordersForBottomView(view: bottomViewWithButton)
        
        // Делаем круг из вью с поздравительным изображением
        viewWithImage.layer.cornerRadius = viewWithImage.frame.size.width / 2
        
        // Текст для подтверждения заказа
        orderConfirmation.text = UtilityManager.shared.orderConfirmation()
    }
    
    
    // MARK: Первый экран
    
    func setupFirstScreenUI(
        viewController: UIViewController,
        tableView: UITableView,
        blueButton: UIButton,
        bottomViewWithButton: UIView,
        whiteView: UIView,
        navigationTitle: String? = nil,
        url: String,
        completion: @escaping (Hotel) -> Void
    ) {
        // Установка делегатов для управления поведением таблицы
        tableView.delegate = viewController as? UITableViewDelegate
        tableView.dataSource = viewController as? UITableViewDataSource
        
        // Настройка закругления кнопки
        UtilityManager.shared.cornerRadius(for: blueButton, radius: 15)
        
        // Настройка границ нижнего вида
        UtilityManager.shared.configureBordersForBottomView(view: bottomViewWithButton)
        
        // Настройка навигационной панели
        UtilityManager.shared.setupNavigationBar(for: viewController)
        
        // Регистрация XIB для ячеек таблицы
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.register(UINib(nibName: "Main2TableViewCell", bundle: nil), forCellReuseIdentifier: "MainSecondCell")
        
        // Запрос данных с удаленного сервера для модели данных
        NetworkManager.shared.getDataFromRemoteServer(urlString: url, tableView: tableView, from: viewController) { hotelData in
            completion(hotelData)
        }
        
        // Чтобы при оттягивании таблицы вниз, пользователь видел белый фон, а не фон таблицы
        TableViewManager.shared.whiteBackgroundWhenPullingTable(view: whiteView, tableView: tableView)
    }
    
    
    // MARK: Второй экран
    
    func setupSecondScreenUI(
        viewController: UIViewController,
        tableView: UITableView,
        navigationTitle: String,
        url: String,
        completion: @escaping (Rooms) -> Void
    ) {
        // Установка делегатов для управления поведением таблицы
        tableView.delegate = viewController as? UITableViewDelegate
        tableView.dataSource = viewController as? UITableViewDataSource
        
        // Настройка навигационной панели
        UtilityManager.shared.setupNavigationBar(for: viewController)
        
        // Регистрация XIB для ячеек таблицы
        tableView.register(UINib(nibName: "SecondTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomsCell")
        
        // Устанавливаем заголовок в качестве названия отеля
        viewController.navigationItem.title = navigationTitle
        
        // Запрос данных с удаленного сервера для модели данных
        NetworkManager.shared.getDataFromRemoteServer(urlString: url, tableView: tableView, from: viewController) { roomsData in
            completion(roomsData)
        }
    }
    
}
