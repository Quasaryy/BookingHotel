//
//  Logger.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import Foundation

struct Logger {
    
    // MARK: - Properties
    
    // Флаг для включения/отключения логирования
    static var isLoggingEnabled = true
    
}

// MARK: - Methods

extension Logger {
    
    
    // Метод для логирования информации об ответе от сервера
    static func logResponse(_ response: URLResponse) {
        guard isLoggingEnabled else { return }
        
        // Проверяем, является ли response экземпляром HTTPURLResponse, чтобы получить HTTP-статус код. В противном случае, просто логируем сам response
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            log("HTTP Status Code: \(statusCode)")
        } else {
            log("URL Response: \(response)")
        }
    }
    
    // Метод для логирования ошибок URLSession с их описанием
    static func logErrorDescription(_ error: Error) {
        guard isLoggingEnabled else { return }
        
        print(error.localizedDescription)
    }
    
    // Общий метод для логирования сообщений
    static func log(_ message: String) {
        guard isLoggingEnabled else { return }
        
        print(message)
    }
    
}
