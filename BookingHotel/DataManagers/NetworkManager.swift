//
//  NetworkManager.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import Foundation
import UIKit

class NetworkManager {
    
    //MARK: - Properties
    
    // Синглтон экземпляр класса NetworkManager, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static let shared = NetworkManager()
    
    // MARK: - Init
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private init() {}
    
}

// MARK: - Methods

extension NetworkManager {
    
    // Метод для получения данных от удаленного сервера. Принимает UITableView и UIViewController для последующей обработки данных и обновления интерфейса
    func getDataFromRemoteServer(tableView: UITableView, from viewController: UIViewController, completion: @escaping (Hotel) -> Void) {
        
        // Создаем URL из строки адреса сервера
        guard let url = URL(string: "https://run.mocky.io/v3/35e0d18e-2521-4f1b-a575-f0fe366f66e3") else { return }
        
        // Создаем URLSessionDataTask для асинхронного получения данных от сервера
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Обрабатываем возможные ошибки, логируя их при помощи Logger-а
            if let error = error {
                Logger.logErrorDescription(error)
                return
            }
            
            // Логируем ответ сервера
            if let response = response {
                Logger.logResponse(response)
            }
            
            // Убеждаемся, что данные от сервера получены
            guard let remoteData = data else { return }
            
            // Пытаемся декодировать данные в модель Hotel
            do {
                let dataModel = try JSONDecoder().decode(Hotel.self, from: remoteData)
                DispatchQueue.main.async {
                    completion(dataModel)
                    tableView.reloadData()
                }
                
                // Логируем ошибку, если не удается декодировать данные
            } catch let error {
                Logger.logErrorDescription(error)
            }
        }.resume() // Запускаем задачу
    }
    
}

