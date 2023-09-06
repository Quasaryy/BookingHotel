//
//  AboutHotel.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import Foundation



import Foundation

// MARK: - Hotel
struct Hotel: Codable {
    let id: Int
    let name, adress: String
    let minimalPrice: Int
    let priceForIt: String
    let rating: Int
    let ratingName: String
    let imageUrls: [String]
    let aboutTheHotel: AboutTheHotel

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
struct AboutTheHotel: Codable {
    let description: String
    let peculiarities: [String]
}
