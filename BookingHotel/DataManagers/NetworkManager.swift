//
//  NetworkManager.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import Foundation
import UIKit

class NetworkManager {
    
    // MARK: - Properties
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static let shared = NetworkManager()
    
    // MARK: - Init
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private init() {}
    
}

// MARK: - Methods

extension NetworkManager {
    
    // Метод для получения данных от удаленного сервера. Принимает UITableView и UIViewController для последующей обработки данных и обновления интерфейса
    func getDataFromRemoteServer<T: Decodable>(urlString: String, tableView: UITableView? = nil, from viewController: UIViewController, completion: @escaping (T) -> Void
    ) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                Logger.logErrorDescription(error)
                return
            }
            
            if let response = response {
                Logger.logResponse(response)
            }
            
            guard let remoteData = data else { return }
            
            do {
                let dataModel = try JSONDecoder().decode(T.self, from: remoteData)
                DispatchQueue.main.async {
                    completion(dataModel)
                    tableView?.reloadData()
                }
            } catch let error {
                Logger.logErrorDescription(error)
            }
        }.resume()
    }
    
}
