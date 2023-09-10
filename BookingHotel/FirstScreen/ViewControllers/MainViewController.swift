//
//  MainViewController.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    // Синглтон модели данных для хранения информации об отеле, хотя для структуры синглтон не нужен
    var dataModelHotel = Hotel.shared
    
    // Для последующего использования для белого фона под таблицей при её оттягивании вниз
    private let whiteView = UIView()
    
    // Урл для URLSession
    private let url = "https://run.mocky.io/v3/35e0d18e-2521-4f1b-a575-f0fe366f66e3"
    
    // MARK: - IB Outlets
    
    // Связывание элементов интерфейса с переменными
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewWithButton: UIView!
    @IBOutlet weak var blueButton: UIButton!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установка делегатов для управления поведением таблицы
        tableView.delegate = self
        tableView.dataSource = self
        
        // Настройка закргуления кнопки
        UtilityManager.shared.cornerRadius(for: blueButton, radius: 15)
        
        // Настройка границ нижнего вида
        UtilityManager.shared.configureBordersForBottomView(view: bottomViewWithButton)
        
        // Настройка навигационной панели
        UtilityManager.shared.setupNavigationBar(for: self)
        
        // Регистрация XIB для ячеек таблицы
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.register(UINib(nibName: "Main2TableViewCell", bundle: nil), forCellReuseIdentifier: "MainSecondCell")
        
        // Запрос данных с удаленного сервера для модели данных
        NetworkManager.shared.getDataFromRemoteServer(urlString: url, tableView: tableView, from: self) { hotel in
            self.dataModelHotel = hotel
        }
        
        // Чтобы при оттягивании таблицы вниз, пользователь видел белый фон, а не фон таблицы
        TableViewManager.shared.wniteBackgroundWnenPullingTable(view: whiteView, tableView: tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Обновляем ширину whiteView, чтобы она соответствовала ширине tableView, чтобы при оттягивании таблици вниз на больших экранах не появлялась серая полоса справа
        whiteView.frame.size.width = tableView.bounds.width
        
        // Устанавливаем дополнительный отступ снизу для tableView
        TableViewManager.shared.additionalPadding(for: -29, tableView: tableView, view: view)
    }
    
    // MARK: - IB Actions
    
    @IBAction func blueButtonTapped(_ sender: UIButton) {
        
        // Настраиваем кнопку назад
        UtilityManager.shared.changeBackButtonTextAndColor(for: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? SecondViewController else { return }
        secondViewController.navigationTitle = dataModelHotel.name
    }
    
}

// MARK: - Table View

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            // Регистрируем ячейку и кастим как кастомную
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
            
            
            // Настройка кастомной ячейки
            mainCell.configCell(dataModel: dataModelHotel)
            
            return mainCell
            
        } else {
            
            // Регистрируем ячейку и кастим как кастомную
            let mainSecondCell = tableView.dequeueReusableCell(withIdentifier: "MainSecondCell", for: indexPath) as! Main2TableViewCell
            
            // Настройка кастомной ячейки
            mainSecondCell.configCell(dataModel: dataModelHotel, indexPath: indexPath)
            
            return mainSecondCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
}

