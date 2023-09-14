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
    private var dataModelHotel = Hotel.shared
    
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
        
        UIManager.shared.setupFirstScreenUI(
            viewController: self,
            tableView: tableView,
            blueButton: blueButton,
            bottomViewWithButton: bottomViewWithButton,
            whiteView: whiteView,
            url: url
        ) { [weak self] hotelData in
            self?.dataModelHotel = hotelData
        }
        
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

