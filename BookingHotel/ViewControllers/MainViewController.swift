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
        
        // Настройка внешнего вида кнопки
        blueButton.layer.cornerRadius = 15
        
        // Настройка границ нижнего вида
        configureBordersForBottomView()
        
        // Настройка навигационной панели
        setupNavigationBar(for: self)
        
        // Регистрация XIB для ячеек таблицы
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.register(UINib(nibName: "Main2TableViewCell", bundle: nil), forCellReuseIdentifier: "MainSecondCell")
        
        // Запрос данных с удаленного сервера для модели данных
        NetworkManager.shared.getDataFromRemoteServer(tableView: tableView, from: self) { hotel in
            self.dataModel = hotel
        }
        
        // Чтобы при оттягивании таблицы вниз, пользователь видел белый фон, а не фон таблицы
        whiteView.frame = CGRect(x: 0, y: -300, width: tableView.bounds.width, height: 300)
        whiteView.backgroundColor = .white
        tableView.addSubview(whiteView)
        
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
            mainCell.selectionStyle = .none
            mainCell.ratingText.text = dataModel.ratingName
            mainCell.ratingNumber.text = String(dataModel.rating)
            mainCell.hotelName.text = dataModel.name
            mainCell.hotelAdress.setTitle(dataModel.adress, for: .normal)
            mainCell.priceFor.text = dataModel.priceForIt
            mainCell.minimalPrice.text = formatMinimalPrice(dataModel.minimalPrice)
            
            // Устанавливаем картинки для слайдера
            mainCell.imageUrls = dataModel.imageUrls
            mainCell.pageControl.numberOfPages = mainCell.imageUrls.count // Обновляем количество страниц для pageControl
            mainCell.collectionView.reloadData() // Перезагружаем данные коллекции
            
            return mainCell
            
        } else {
            
            // Регистрируем ячейку и кастим как кастомную
            let mainSecondCell = tableView.dequeueReusableCell(withIdentifier: "MainSecondCell", for: indexPath) as! Main2TableViewCell
            
            // Настройка кастомной ячейки
            mainSecondCell.selectionStyle = .none
            mainSecondCell.configLabelsWithData(with: dataModel)
            mainSecondCell.hotelDescription.text = dataModel.aboutTheHotel.description
            
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

// MARK: - Methods

extension MainViewController {
    
    func configureBordersForBottomView() {
        // Настройка границ для bottomView
        bottomViewWithButton.layer.borderWidth = 1
        bottomViewWithButton.layer.borderColor = UIColor(red: 232/255, green: 233/255, blue: 236/255, alpha: 1).cgColor
    }
    
    func setupNavigationBar(for viewController: UIViewController) {
        // Настройка внешнего вида навигационной панели
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        viewController.navigationController?.navigationBar.standardAppearance = appearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        guard let font = UIFont(name: "SFProDisplay-Medium", size: 18) else { return }
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: font]
    }
    
    // Функция для форматирования минимальной цены с добавлением разделителя тысяч
    func formatMinimalPrice(_ minimalPrice: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        if let formattedNumber = formatter.string(from: NSNumber(value: minimalPrice)) {
            return "от \(formattedNumber) ₽"
        } else {
            return "Цена не доступна"
        }
    }
    
}

