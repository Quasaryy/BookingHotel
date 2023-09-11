//
//  TextFieldManager.swift
//  BookingHotel
//
//  Created by Yury on 11/09/2023.
//

import Foundation
import UIKit

class TextFieldManager: NSObject {
    
    // MARK: - Properties
    
    // Размер плейсхолдера
    let sizeSmallPlaceholder: CGFloat = 12
    let sizeNormalPlaceHolder: CGFloat = 17
    
    // Высота текстовго поля
    let textFieldHeight: CGFloat = 52
    
    // Смешение текста от левого края
    let leftPadding: CGFloat = 16
    
    // Позиция маленького плейсхолдера
    let placeholderPosotion: CGFloat = 8
    
    // Позиция текста
    let textPosition: CGFloat = -8
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static var shared = TextFieldManager()
    
}

// MARK: - Text field delegate

extension TextFieldManager: UITextFieldDelegate {
    
    // Методы делегата UITextField для анимации плейсхолдера
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let placeholderLabel = textField.viewWithTag(100) as? UILabel {
            UIView.animate(withDuration: 0.3) {
                placeholderLabel.font = UIFont(name: "SFProDisplay-Regular", size: self.sizeSmallPlaceholder)
                placeholderLabel.frame.origin = CGPoint(x: self.leftPadding, y: self.placeholderPosotion)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let placeholderLabel = textField.viewWithTag(100) as? UILabel, textField.text?.isEmpty == true {
            UIView.animate(withDuration: 0.3) {
                placeholderLabel.font = UIFont(name: "SFProDisplay-Regular", size: self.sizeNormalPlaceHolder)
                placeholderLabel.frame.origin = CGPoint(x: self.leftPadding, y: (self.textFieldHeight - self.sizeNormalPlaceHolder) / 2)
            }
        }
    }
    
    // Настройка текстовых полей
    func textFiledsConfig(for textFields: [UITextField], radius: CGFloat) {
        for textField in textFields {
            
            textField.layer.cornerRadius = radius
            
            textField.delegate = self
            
            textField.defaultTextAttributes.updateValue(textPosition, forKey: NSAttributedString.Key.baselineOffset)
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: textField.frame.height))
            
            textField.leftView = paddingView
            textField.leftViewMode = .always
            
            let placeholderLabel = UILabel()
            placeholderLabel.text = textField.placeholder
            placeholderLabel.font = UIFont(name: "SFProDisplay-Regular", size: sizeNormalPlaceHolder)
            placeholderLabel.textColor = UIColor(red: 169/255, green: 171/255, blue: 183/255, alpha: 1)
            placeholderLabel.frame.size = CGSize(width: textField.frame.width - 32, height: 20)
            placeholderLabel.frame.origin = CGPoint(x: leftPadding, y: (textField.frame.height - sizeSmallPlaceholder) / 2)
            
            if let placeholder = textField.placeholder {
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.clear
                ]
                textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            }
            
            placeholderLabel.tag = 100
            textField.addSubview(placeholderLabel)
        }
    }
    
}
