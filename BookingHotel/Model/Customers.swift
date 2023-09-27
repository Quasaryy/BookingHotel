//
//  Customers.swift
//  BookingHotel
//
//  Created by Yury on 10/09/2023.
//

import Foundation

// MARK: - Customers

struct Customers: Codable {
    let id: Int
    let hotelName: String
    let hotelAdress: String
    let horating: Int
    let ratingName: String
    let departure: String
    let arrivalCountry: String
    let tourDateStart: String
    let tourDateStop: String
    let numberOfNights: Int
    let room, nutrition: String
    let tourPrice: Int
    let fuelCharge: Int
    let serviceCharge: Int

    // Перечисление для задания ключей декодирования, чтобы переделать некоторые snake_case константы в camelCase формат
    enum CodingKeys: String, CodingKey {
        case id
        case hotelName = "hotel_name"
        case hotelAdress = "hotel_adress"
        case horating
        case ratingName = "rating_name"
        case departure
        case arrivalCountry = "arrival_country"
        case tourDateStart = "tour_date_start"
        case tourDateStop = "tour_date_stop"
        case numberOfNights = "number_of_nights"
        case room, nutrition
        case tourPrice = "tour_price"
        case fuelCharge = "fuel_charge"
        case serviceCharge = "service_charge"
    }
    
    static var shared = Customers(id: Int(), hotelName: String(), hotelAdress: String(), horating: Int(), ratingName: String(), departure: String(), arrivalCountry: String(), tourDateStart: String(), tourDateStop: String(), numberOfNights: Int(), room: String(), nutrition: String(), tourPrice: Int(), fuelCharge: Int(), serviceCharge: Int())
}
