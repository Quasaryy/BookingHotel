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
                
            }
        }
        
        // Закругляем вьюхи
        for view in views {
            UtilityManager.shared.cornerRadius(for: view, radius: 15)
        }
        
        // Настроиваем текстовые поля
        TextFieldManager.shared.textFiledsConfig(for: textFields, radius: 10)
        
        // Настраиваем блок с оценкой отеля
        UtilityManager.shared.hotelLevel(stackView: stackViewWithStar)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
