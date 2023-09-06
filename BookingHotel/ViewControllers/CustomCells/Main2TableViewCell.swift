//
//  Main2TableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import UIKit

class Main2TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear // Задаем прозрачный фон для ячейки
        self.contentView.backgroundColor = .white
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
