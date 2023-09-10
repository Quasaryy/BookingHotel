//
//  ThirdViewController.swift
//  BookingHotel
//
//  Created by Yury on 10/09/2023.
//

import UIKit

class ThirdViewController: UIViewController {

    // MARK: - Properties
        
    // Синглтон модели данных для хранения информации об отеле, хотя для структуры синглтон не нужен
    var dataModelCustomers = Customers.shared
    
    // Урл для URLSession
    private let url = "https://run.mocky.io/v3/e8868481-743f-4eb2-a0d7-2bc4012275c8"
        
    // MARK: - IB Outlets
    
    // Связывание элементов интерфейса с переменными
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установка делегатов для управления поведением таблицы
        tableView.delegate = self
        tableView.dataSource = self
        
        // Настройка навигационной панели
        UtilityManager.shared.setupNavigationBar(for: self)
        
        // Регистрация XIB для ячеек таблицы
        tableView.register(UINib(nibName: "ThirdTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomersCell")
        
        // Запрос данных с удаленного сервера для модели данных
        NetworkManager.shared.getDataFromRemoteServer(urlString: url, tableView: tableView, from: self) { customers in
            self.dataModelCustomers = customers
        }
    }

}

// MARK: - Table View

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Регистрируем ячейку и кастим как кастомную
        let customersCell = tableView.dequeueReusableCell(withIdentifier: "CustomersCell", for: indexPath) as! ThirdTableViewCell
        
        // Настройка кастомной ячейки
        //customersCell.configCell(dataModel: dataModelCustomers, indexPath: indexPath, delegate: self)
        
        return customersCell
    }
    
    // Задаем высоту футера для последней секции, чтобы создать отступ
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    // Добавляем view для футера, чтобы он был видимым
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
}

extension ThirdViewController: SecondTableViewCellDelegate {
    
    func chooseRoomButtonTapped(cell: SecondTableViewCell) {
            performSegue(withIdentifier: "ToFinalScreen", sender: nil)
        }
    
    func changeBackButtonTextAndColor() {
            UtilityManager.shared.changeBackButtonTextAndColor(for: self)
        }
    
}
