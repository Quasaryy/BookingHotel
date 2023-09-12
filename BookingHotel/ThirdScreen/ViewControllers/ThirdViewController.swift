//
//  ThirdViewController.swift
//  BookingHotel
//
//  Created by Yury on 11/09/2023.
//

import UIKit

class ThirdViewController: UIViewController {
    
    // MARK: - Propertis
    
    // Синглтон модели данных для хранения информации об отеле, хотя для структуры синглтон не нужен
    var dataModelCustomers  = Customers.shared
    
    // Урл для URLSession
    private let url = "https://run.mocky.io/v3/e8868481-743f-4eb2-a0d7-2bc4012275c8"
    
    // MARK: - IB Outlets
    // Аутлеты для различных UI элементов
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var buttonsUpDownPlus: [UIButton]!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var fuelPrice: UILabel!
    @IBOutlet weak var tourPrice: UILabel!
    @IBOutlet weak var stackViewForView4: UIStackView!
    @IBOutlet weak var viewWithButton: UIView!
    @IBOutlet weak var payButtom: UIButton!
    @IBOutlet weak var stackViewForView5: UIStackView!
    @IBOutlet weak var view5HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view4HeightConstraint: NSLayoutConstraint!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var stackViewWithStar: UIStackView!
    @IBOutlet weak var hotelAdress: UIButton!
    @IBOutlet var hotelName: [UILabel]!
    @IBOutlet weak var howMuchNights: UILabel!
    @IBOutlet weak var flyTo: UILabel!
    @IBOutlet weak var flyFrom: UILabel!
    @IBOutlet weak var aboutRoom: UILabel!
    @IBOutlet weak var foodKind: UILabel!
    @IBOutlet weak var hotelGradeNumber: UILabel!
    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var hotelGrade: UILabel!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Запрос данных с удаленного сервера для модели данных
        NetworkManager.shared.getDataFromRemoteServer(urlString: url, from: self) { (customers: Customers) in
            
            // Записываем данные в модель
            self.dataModelCustomers = customers
            
            // Присваиваем из модели данные аутлетам
            DispatchQueue.main.async {
                for hotel in self.hotelName {
                    hotel.text = self.dataModelCustomers.hotelName
                }
                self.hotelAdress.setTitle(self.dataModelCustomers.hotelAdress, for: .normal)
                self.flyFrom.text = self.dataModelCustomers.departure
                self.flyTo.text = self.dataModelCustomers.arrivalCountry
                self.hotelGrade.text  = self.dataModelCustomers.ratingName
                self.hotelGradeNumber.text =  String(self.dataModelCustomers.horating)
                self.aboutRoom.text = self.dataModelCustomers.room
                self.foodKind.text = self.dataModelCustomers.nutrition
                self.howMuchNights.text = String(self.dataModelCustomers.numberOfNights)
                self.dates.text = "\(self.dataModelCustomers.tourDateStart) - \(self.dataModelCustomers.tourDateStop)"
                self.fuelPrice.text = String(self.dataModelCustomers.fuelCharge)
                self.servicePrice.text = UtilityManager.shared.formatMinimalPrice(self.dataModelCustomers.serviceCharge, withPrefix: false)
                self.fuelPrice.text = UtilityManager.shared.formatMinimalPrice(self.dataModelCustomers.fuelCharge, withPrefix: false)
                self.tourPrice.text = UtilityManager.shared.formatMinimalPrice(self.dataModelCustomers.tourPrice, withPrefix: false)
                self.totalPrice.text = UtilityManager.shared.formatMinimalPrice(self.dataModelCustomers.tourPrice + self.dataModelCustomers.fuelCharge + self.dataModelCustomers.serviceCharge, withPrefix: false)
                if let totalPrice = self.totalPrice.text {
                    self.payButtom.setTitle("Оплатить \(totalPrice)", for: .normal)
                }
                
            }
        }
        
        // Закругляем вьюхи
        for view in views {
            UtilityManager.shared.cornerRadius(for: view, radius: 15)
        }
        
        // Закругляем кнопки свернуть, развернуть, добавить
        for button in buttonsUpDownPlus {
            UtilityManager.shared.cornerRadius(for: button, radius: 6)
        }
        
        // Закругляем кнопку оплатить
        UtilityManager.shared.cornerRadius(for: payButtom, radius: 15)
        
        // Настроиваем текстовые поля
        TextFieldManager.shared.textFiledsConfig(for: textFields, radius: 10)
        
        // Настраиваем блок с оценкой отеля
        UtilityManager.shared.hotelLevel(stackView: stackViewWithStar)
        
        // Скрываем стек свернуой секции
        stackViewForView5.isHidden = true
        
        // Задаем бордер для последней секции
        UtilityManager.shared.configureBordersForBottomView(view: viewWithButton)
        
        // Вызываем метод для настройки скрытия клавиатуры при тапе вне текстого поля
        TextFieldManager.shared.setupGestureToHideKeyboard(viewController: self)
        
        // Вызываем метод для настройки скрытия клавиатуры при скролле
        ScrollViewManager.shared.setupToHideKeyboardOnScroll(scrollView: scrollView, viewController: self)
        
    }
    
    // MARK: IB Actions
    
    // Сворачивание и разворачивание секции
    @IBAction func upOrDownArrowButtonTapped(_ sender: UIButton) {
        switch sender.tag {
            case 4:
                UtilityManager.shared.changeSizeforView(constraint: view4HeightConstraint, stackView: stackViewForView4, sender: sender, in: self.view)
            case 5:
                UtilityManager.shared.changeSizeforView(constraint: view5HeightConstraint, stackView: stackViewForView5, sender: sender, in: self.view)
            default:
                break
        }
    }
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        // Переменная для отслеживания, есть ли незаполненные поля
        var hasEmptyField = false
        
        // Отсортируем поля перед проверкой
        textFields.sort { $0.frame.origin.y < $1.frame.origin.y }
        
        for textField in textFields {
            if textField.text?.isEmpty ?? true {
                // Помечаем, что есть незаполненное поле
                hasEmptyField = true
                textField.backgroundColor = UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 0.15)
            }
        }
        
        // Проверяем, есть ли незаполненные поля
        if hasEmptyField {
            // Показываем уведомление что не все поля заполнены
            UtilityManager.shared.showAlert(from: self, title: "Не все поля заполнены или заполнены не корректно", message: "Проверьте все поля помеченные красным, возможно вы забыли заполнить данные для второго туриста")
        } else {
            // Нет незаполненных полей, выполняем переход по сегвею
            UtilityManager.shared.changeBackButtonTextAndColor(for: self)
            performSegue(withIdentifier: "ToFinalScreen", sender: self)
        }
    }
    
}

