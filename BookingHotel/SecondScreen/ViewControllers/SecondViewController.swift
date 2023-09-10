//
//  SecondViewController.swift
//  BookingHotel
//
//  Created by Yury on 09/09/2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    // MARK: - Properties
    
    // Получаем название отеля из предыдущего контроллера
    var navigationTitle: String?
    
    // Синглтон модели данных для хранения информации об отеле, хотя для структуры синглтон не нужен
    var dataModelRooms = Rooms.shared
    
    // Урл для URLSession
    private let url = "https://run.mocky.io/v3/f9a38183-6f95-43aa-853a-9c83cbb05ecd"
        
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
        tableView.register(UINib(nibName: "SecondTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomsCell")
        
        // Устанавливаем заголовок в качестве названия отеля
        navigationItem.title = navigationTitle
        
        // Запрос данных с удаленного сервера для модели данных
        NetworkManager.shared.getDataFromRemoteServer(urlString: url, tableView: tableView, from: self) { rooms in
            self.dataModelRooms = rooms
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Устанавливаем дополнительный отступ снизу для tableView
        TableViewManager.shared.additionalPadding(for: -33, tableView: tableView, view: view)
    }
    
}


// MARK: - Table View

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModelRooms.rooms.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Регистрируем ячейку и кастим как кастомную
        let roomsCell = tableView.dequeueReusableCell(withIdentifier: "RoomsCell", for: indexPath) as! SecondTableViewCell
        
        // Настройка кастомной ячейки
        roomsCell.configCell(dataModel: dataModelRooms, indexPath: indexPath, delegate: self)
        
        return roomsCell
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

extension SecondViewController: SecondTableViewCellDelegate {
    
    func chooseRoomButtonTapped(cell: SecondTableViewCell) {
            performSegue(withIdentifier: "ToCustomerScreen", sender: nil)
        }
    
    func changeBackButtonTextAndColor() {
            UtilityManager.shared.changeBackButtonTextAndColor(for: self)
        }
    
}
