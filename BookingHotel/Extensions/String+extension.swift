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
        // Создаем прямоугольник с максимально возможной шириной и заданной высотой, чтобы определить максимальную ширину, которую может занять данная строка
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        // Вычисляем и возвращаем ширину строки, используя метод boundingRect
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font], // Устанавливаем шрифт для расчета размера строки
            context: nil
        )
        
        // Возвращаем ширину bounding box, округленную в большую сторону, чтобы избежать возможного обрезания текста
        return ceil(boundingBox.width)
    }
}
