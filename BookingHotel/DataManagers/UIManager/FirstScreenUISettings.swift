//
//  FirstScreenUISettings.swift
//  BookingHotel
//
//  Created by Yury on 28/09/2023.
//

import UIKit

struct FirstScreenUISettings {
    let viewController: UIViewController
    let tableView: UITableView
    let blueButton: UIButton
    let bottomViewWithButton: UIView
    let whiteView: UIView
    let navigationTitle: String?
    let url: String
    let completion: (Hotel) -> Void
}
