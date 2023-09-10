//
//  SecondCollectionViewCell.swift
//  BookingHotel
//
//  Created by Yury on 09/09/2023.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {

    // MARK: - IB Outlets
    
    // Outlet для UIImageView, который будет отображать изображение в ячейке
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

// MARK: - Slider Delegate

extension SecondCollectionViewCell: SliderImageViewCell {}
