//
//  Rooms.swift
//  BookingHotel
//
//  Created by Yury on 08/09/2023.
//

import Foundation

// MARK: - Welcome
struct Rooms: Codable {
    let rooms: [Room]
    
    static var shared = Rooms(rooms: [Room]())
}

// MARK: - Room
struct Room: Codable {
    let id: Int
    let name: String
    let price: Int
    let pricePer: String
    let peculiarities: [String]
    let imageUrls: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case pricePer = "price_per"
        case peculiarities
        case imageUrls = "image_urls"
    }
}
