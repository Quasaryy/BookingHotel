//
//  MainViewController.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    // Синглтон модели данных для хранения информации об отеле, хотя для структуры синглтон не нужен но так красивее :)
    var dataModel = Hotel.shared
    
    // Для последующего использования для белого фона под таблицей при её оттягивании вниз
    let whiteView = UIView()
    
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
        
        // Настройка внешнего вида таблицы
        tableView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
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
        NetworkManager.shared.getDataFromRemoteServer(tableView: tableView, from: self) { hotel in
            self.dataModel = hotel
        }
        
        // Чтобы при оттягивании таблицы вниз, пользователь видел белый фон, а не фон таблицы
        TableViewManager.shared.wniteBackgroundWnenPullingTable(view: whiteView, tableView: tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Обновляем ширину whiteView, чтобы она соответствовала ширине tableView, чтобы при оттягивании таблици вниз на больших экранах не появлялась серая полоса справа
        whiteView.frame.size.width = tableView.bounds.width
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

// MARK: - Table View

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            // Регистрируем ячейку и кастим как кастомную
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
            
            
            // Настройка кастомной ячейки
            mainCell.configCell(dataModel: dataModel)
            
            return mainCell
            
        } else {
            
            // Регистрируем ячейку и кастим как кастомную
            let mainSecondCell = tableView.dequeueReusableCell(withIdentifier: "MainSecondCell", for: indexPath) as! Main2TableViewCell
            
            // Настройка кастомной ячейки
            mainSecondCell.configCell(dataModel: dataModel)
            
            return mainSecondCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
        return footerView
    }
    
}

