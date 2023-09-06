//
//  NetworkManager.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import Foundation

import Foundation
import UIKit

class NetworkManager {
    
    //MARK: - Properties
    static let shared = NetworkManager()
    
    // MARK: - Init
    private init() {}
    
}

extension NetworkManager {
    
    func getDataFromRemoteServer(tableView: UITableView, from viewController: UIViewController, completion: @escaping (Hotel) -> Void) {
        
        guard let url = URL(string: "https://run.mocky.io/v3/35e0d18e-2521-4f1b-a575-f0fe366f66e3") else { return }
        
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
                let dataModel = try JSONDecoder().decode(Hotel.self, from: remoteData)
                DispatchQueue.main.async {
                    completion(dataModel)
                    tableView.reloadData()
                }
            } catch let error {
                Logger.logErrorDescription(error)
            }
        }.resume()
    }
    
}

