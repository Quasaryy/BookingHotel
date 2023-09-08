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
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static let shared = NetworkManager()
    
    // MARK: - Init
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private init() {}
    
}

// MARK: - Methods

extension NetworkManager {
    
    // Метод для получения данных от удаленного сервера. Принимает UITableView и UIViewController для последующей обработки данных и обновления интерфейса
    func getDataFromRemoteServer<T: Decodable>(urlString: String, tableView: UITableView, from viewController: UIViewController, completion: @escaping (T) -> Void) {
        
        // Создаем URL из строки адреса сервера
        guard let url = URL(string: urlString) else { return }
        
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
            
            // Пытаемся декодировать данные в модель
            do {
                let dataModel = try JSONDecoder().decode(T.self, from: remoteData)
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

