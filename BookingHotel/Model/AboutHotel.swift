//
//  AboutHotel.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import Foundation

// MARK: - Hotel

// Структура, представляющая данные отеля
struct Hotel: Codable {
    let id: Int
    let name: String
    let adress: String
    let minimalPrice: Int
    let priceForIt: String
    let rating: Int
    let ratingName: String
    let imageUrls: [String]
    let aboutTheHotel: AboutTheHotel

    // Перечисление для задания ключей декодирования, чтобы переделать некоторые snake_case константы в camelCase формат
    enum CodingKeys: String, CodingKey {
        case id, name, adress
        case minimalPrice = "minimal_price"
        case priceForIt = "price_for_it"
        case rating
        case ratingName = "rating_name"
        case imageUrls = "image_urls"
        case aboutTheHotel = "about_the_hotel"
    }
    
    static var shared = Hotel(id: Int(), name: String(), adress: String(), minimalPrice: Int(), priceForIt: String(), rating: Int(), ratingName: String(), imageUrls: [String](), aboutTheHotel: AboutTheHotel(description: String(), peculiarities: [String]()))
}

// MARK: - AboutTheHotel

// Структура для хранения детальной информации об отеле
struct AboutTheHotel: Codable {
    let description: String
    let peculiarities: [String]
}
