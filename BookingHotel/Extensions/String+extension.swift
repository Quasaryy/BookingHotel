//
//  String+extension.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import UIKit

extension String {
    /// Возвращает ширину строки при заданной высоте и шрифте
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        
        return ceil(boundingBox.width)
    }
}
