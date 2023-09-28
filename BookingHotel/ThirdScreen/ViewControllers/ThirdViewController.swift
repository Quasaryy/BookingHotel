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
    private var dataModelCustomers  = Customers.shared
    // Урл для URLSession
    private let url = "https://run.mocky.io/v3/e8868481-743f-4eb2-a0d7-2bc4012275c8"
    // Переменная для отслеживания текущего индекса скрытого вью
    private var currentViewIndex = 4
    // Создаем обект PaymentHandler
    lazy var paymentHandler: PaymentHandler = {
        return PaymentHandler(viewController: self,
                              textFields: textFields,
                              views: views,
                              viewConstraints: viewConstaraints,
                              stacksInViews: stacksInViews,
                              buttonsUpDownPlus: buttonsUpDownPlus,
                              scrollView: scrollView,
                              mainStackView: mainStackView)
    }()
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var buttonsUpDownPlus: [UIButton]!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var fuelPrice: UILabel!
    @IBOutlet weak var tourPrice: UILabel!
    @IBOutlet weak var viewWithButton: UIView!
    @IBOutlet weak var payButtom: UIButton!
    @IBOutlet var stacksInViews: [UIStackView]!
    @IBOutlet var viewConstaraints: [NSLayoutConstraint]!
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
                self.updateUIWithModelData()
            }
        }
        
        // Первоначальная настройка UI
        setupUI()
    }
    
    // MARK: - IB Actions
    
    // Создание нового клиента
    @IBAction func addNewCustomer(_ sender: UIButton) {
        ActionManager.shared.addNewCustomer(currentViewIndex: &currentViewIndex, mainStackView: mainStackView, controller: self)
    }
    
    // Сворачивание и разворачивание секции
    @IBAction func upOrDownArrowButtonTapped(_ sender: UIButton) {
        let tagOffset = 20
        ActionManager.shared.toggleSectionVisibility(sender: sender, constraints: viewConstaraints, stackViews: stacksInViews, in: self.view, withTag: tagOffset)
    }
    
    // Кнопка оплатить
    @IBAction func payButtonTapped(_ sender: UIButton) {
        paymentHandler.handlePaymentAction(for: sender)
    }
    
}

// MARK: - Private methods

extension ThirdViewController {
    
    // Первоначальная настройка UI
    private func setupUI() {
        UIManager.shared.setupViewElements(views: views)
        UIManager.shared.setupButtons(buttons: buttonsUpDownPlus, radius: 6)
        UIManager.shared.setupButtons(buttons: [payButtom], radius: 15)
        UIManager.shared.setupTextFields(textFields: textFields, radius: 10)
        UIManager.shared.setupStackViewWithStar(stackView: stackViewWithStar)
        UIManager.shared.setupViewWithBorder(view: viewWithButton)
        UIManager.shared.setupKeyboardHiding(viewController: self, scrollView: scrollView)
    }
    
    // Присваиваем из модели данные аутлетам
    private func updateUIWithModelData() {
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
