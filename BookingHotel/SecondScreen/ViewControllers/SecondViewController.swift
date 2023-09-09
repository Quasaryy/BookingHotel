//
//  SecondViewController.swift
//  BookingHotel
//
//  Created by Yury on 09/09/2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    // MARK: - Properties
    
    var navigationTitle: String?
    
    // Синглтон модели данных для хранения информации об отеле, хотя для структуры синглтон не нужен
    var dataModelRooms = Rooms.shared
    
    // Урл для URLSession
    private let url = "https://run.mocky.io/v3/f9a38183-6f95-43aa-853a-9c83cbb05ecd"
    
    // MARK: - IB Outlets
    
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
        
        navigationItem.title = navigationTitle
        
        NetworkManager.shared.getDataFromRemoteServer(urlString: url, tableView: tableView, from: self) { rooms in
            self.dataModelRooms = rooms
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
            //mainCell.configCell(dataModel: dataModelHotel)
            
            return roomsCell
            
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
