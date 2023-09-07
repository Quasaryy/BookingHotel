//
//  CollectionViewCell.swift
//  BookingHotel
//
//  Created by Yury on 05/09/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - IB Outlets
    
    // Outlet для UIImageView, который будет отображать изображение в ячейке
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
