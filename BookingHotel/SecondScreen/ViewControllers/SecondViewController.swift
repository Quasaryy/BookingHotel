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
    private var dataModelRooms = Rooms.shared
    
    // Урл для URLSession
    private let url = "https://run.mocky.io/v3/2a8ee4bb-ab26-4587-8881-bc85462a50c1"
        
    // MARK: - IB Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstrantForTableView: NSLayoutConstraint!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Первоначальная настройка UI
        UIManager.shared.setupSecondScreenUI(
            viewController: self,
            tableView: tableView,
            navigationTitle: navigationTitle ?? "Default Title",
            url: url
        ) { [weak self] rooms in
            self?.dataModelRooms = rooms
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
        guard let roomsCell = tableView.dequeueReusableCell(withIdentifier: "RoomsCell", for: indexPath) as? SecondTableViewCell else { return UITableViewCell() }
        
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

// MARK: - Scroll view delegate

extension SecondViewController {
    
    // Метод делегата скролл вью чтобы убрать серую полоску сверху при скроллинге талицы вверх и сделать прсто бордер
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            topConstrantForTableView.constant = 1
        } else {
            topConstrantForTableView.constant = 8
        }
    }
}
