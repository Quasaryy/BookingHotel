//
//  MainViewController.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var dataModel = Hotel.shared
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewWithButton: UIView!
    @IBOutlet weak var blueButton: UIButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавляем делагаты для таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
        
        
        blueButton.layer.cornerRadius = 15
        configureBordersForBottomView()
        
        setupNavigationBar(for: self)
        
        
        // Регистрируем xib
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.register(UINib(nibName: "Main2TableViewCell", bundle: nil), forCellReuseIdentifier: "MainSecondCell")
        
        // Getting data from remote server for data model
        NetworkManager.shared.getDataFromRemoteServer(tableView: tableView, from: self) { hotel in
            self.dataModel = hotel
        }
        
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

// MARK: - Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View
    
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

extension MainViewController {
    
    func configureBordersForBottomView() {
        
        bottomViewWithButton.layer.borderWidth = 1
        bottomViewWithButton.layer.borderColor = UIColor(red: 232/255, green: 233/255, blue: 236/255, alpha: 1).cgColor
    }
}

extension MainViewController {
    
    func setupNavigationBar(for viewController: UIViewController) {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        viewController.navigationController?.navigationBar.standardAppearance = appearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        guard let font = UIFont(name: "SFProDisplay-Medium", size: 18) else { return }
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: font]
    }
}

extension MainViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

extension MainViewController {
    
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

