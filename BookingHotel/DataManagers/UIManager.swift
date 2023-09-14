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
    
    // MARK: - Первый экран
    
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
    
    // MARK: Первая кастомная ячейка
    
    // Метод для настройки вида ячейки
    func setupFirstCustomCellForFirstScreen(customCell: MainTableViewCell, shouldApplyCornerRadius: Bool) {
        TableViewManager.shared.setupViewAppearance(customCell: customCell, shouldApplyCornerRadius: shouldApplyCornerRadius)
    }
    
    // Метод для настройки stackView
    func setupCustomCellStackView(stackView: UIStackView) {
        UtilityManager.shared.hotelLevel(stackView: stackView)
    }
    
    // Метод для настройки закругления углов viewWithPagination
    func setupViewWithPaginationCornerRadius(for view: UIView) {
        UtilityManager.shared.cornerRadius(for: view, radius: 5)
    }
    
    // Метод для настройки закругления углов collectionView
    func setupCollectionViewCornerRadius(for view: UIView) {
        UtilityManager.shared.cornerRadius(for: view, radius: 15)
    }
    
    // Метод для регистрации XIB для collectionView
    func registerCustomCellNibs(collectionView: UICollectionView) {
        let nib = UINib(nibName: "MainCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "СollectionViewCell")
    }
    
    // Метод для настройки фона collectionView
    func setupCustomCellCollectionViewBackgroundColor(collectionView: UICollectionView, color: UIColor) {
        collectionView.backgroundColor = color
    }
    
    // Метод для настройки слайдера
    func setupSliderForCustomCell(cell: MainTableViewCell, imageUrls: [String]) {
        SliderManager.shared.delegate = cell
        SliderManager.shared.imageUrls = imageUrls
        SliderManager.shared.configureSlider(for: cell)
    }
    
    // Метод для настройки PageControl
    func setupPageControlForCustomCell(pageControl: UIPageControl, numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    // MARK: Вторая кастомная чейка
    
    // Настройка вложенного контроллера таблицы
    func setupNestedTableViewControllerInCell(for cell: UITableViewCell) {
        guard let checkedCell = cell as? Main2TableViewCell else { return }
        TableViewManager.shared.setupNestedTableViewControllerInCell(for: checkedCell as Main2TableViewCell)
    }
    
    // Настройка внешнего вида ячейки
    func setupViewAppearance(customCell: UITableViewCell) {
        TableViewManager.shared.setupViewAppearance(customCell: customCell)
    }
    
    
    // MARK: - Второй экран
    
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
    
    // MARK: Кастомная ячейка
    
    func setupCustomCellForSecondScreen(
        chooseRoomButton: UIButton,
        viewWithPagination: UIView,
        collectionView: UICollectionView,
        moreAboutRoomButton: UIButton,
        cell: UITableViewCell
    ) {
        // Настройка закругления кнопки
        UtilityManager.shared.cornerRadius(for: chooseRoomButton, radius: 15)
        
        // Настройка вида ячейки
        TableViewManager.shared.setupViewAppearance(customCell: cell)
        
        // Регистрация XIB для collectionView
        let nib = UINib(nibName: "SecondCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "СollectionViewCell")
        
        // Настройка закругления view для пагинации
        UtilityManager.shared.cornerRadius(for: viewWithPagination, radius: 5)
        
        // Округление углов collectionView
        UtilityManager.shared.cornerRadius(for: collectionView, radius: 15)
        
        // Закругление кнопки moreAboutRoomButton
        UtilityManager.shared.cornerRadius(for: moreAboutRoomButton, radius: 5)
        
        // Устанавливаем белый цвет фона для UICollectionView
        collectionView.backgroundColor = .white
    }
    
    // MARK: - Третий экран
    
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
    
    // MARK: - Четвертый экран
    
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
    
}
