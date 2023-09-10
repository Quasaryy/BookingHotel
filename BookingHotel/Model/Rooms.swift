//
//  Rooms.swift
//  BookingHotel
//
//  Created by Yury on 08/09/2023.
//

import Foundation

// MARK: - Rooms

// Структура, представляющая данные номеров
struct Rooms: Codable {
    let rooms: [Room]
    
    static var shared = Rooms(rooms: [Room]())
}

// MARK: - Room

// Структура для хранения детальной информации о номерах
struct Room: Codable {
    let id: Int
    let name: String
    let price: Int
    let pricePer: String
    let peculiarities: [String]
    let imageUrls: [String]

    // Перечисление для задания ключей декодирования, чтобы переделать некоторые snake_case константы в camelCase формат
    enum CodingKeys: String, CodingKey {
        case id, name, price
        case pricePer = "price_per"
        case peculiarities
        case imageUrls = "image_urls"
    }
}
