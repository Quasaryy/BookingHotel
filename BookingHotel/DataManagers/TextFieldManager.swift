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
    
    weak var viewController: UIViewController?
    
    // Размер плейсхолдера
    private let sizeSmallPlaceholder: CGFloat = 12
    private let sizeNormalPlaceHolder: CGFloat = 17
    
    // Высота текстовго поля
    private let textFieldHeight: CGFloat = 52
    
    // Смешение текста от левого края
    private let leftPadding: CGFloat = 16
    
    // Позиция маленького плейсхолдера
    private let placeholderPosotion: CGFloat = 10
    
    // Позиция текста
    private let textPosition: CGFloat = -8
    
    // Настройка позиции плейсхолдера по умолчанию
    private let placeholderAdjustment: CGFloat = 1.0
    
    private var previousText: String?
    
    // Синглтон экземпляр класса
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
        
        // Устанавливаем маску для ввода номера телефона, если поле для ввода пустое или nil
        if textField.placeholder == "Номер телефона" && (textField.text == nil || textField.text?.isEmpty == true) {
            textField.text = "+7 (***) ***-**-**"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let placeholderLabel = textField.viewWithTag(100) as? UILabel, textField.text?.isEmpty == true {
            // Если текстовое поле пустое после окончания редактирования, возвращаем плейсхолдер на исходную позицию с анимацией
            UIView.animate(withDuration: 0.3) {
                placeholderLabel.font = UIFont(name: "SFProDisplay-Regular", size: self.sizeNormalPlaceHolder)
                placeholderLabel.frame.origin = CGPoint(x: self.leftPadding, y: (self.textFieldHeight - self.sizeNormalPlaceHolder) / 2)
            }
            // Удаляем текст из текстового поля
            //textField.text = nil
            textField.backgroundColor = UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 0.15)
        } else {
            // Если поле не пустое, возвращаем его старую окраску
            textField.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 249/255, alpha: 1)
        }
        
        // Проверка на правильность email и изменение цвета
        if textField.placeholder == "Почта" {
            if let email = textField.text, !isValidEmail(email) {
                // Email неверный - закрашиваем поле в цвет ошибки
                textField.backgroundColor = UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 0.15)
            } else {
                // Email верный - устанавливаем цвет текста на обычный
                textField.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 249/255, alpha: 1)
            }
        }
        
        // Проверка на полноту ввода номера телефона и изменение цвета
        if textField.placeholder == "Номер телефона" {
            let phoneNumber = textField.text ?? ""
            
            // Проверяем, содержит ли номер телефона звездочки
            if phoneNumber.contains("*") {
                textField.backgroundColor = UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 0.15)
            } else {
                textField.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 249/255, alpha: 1)
            }
        }
    }
    
    // Настройка текстовых полей
    func textFiledsConfig(for textFields: [UITextField], radius: CGFloat) {
        for textField in textFields {
            
            // Добавляем кнопку очистки, чтобы она была видна так же в темном режиме
            textField.clearButtonMode = .whileEditing
            if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
                clearButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
                clearButton.tintColor = UIColor.gray
            }
            
            // Устанавливаем скругление углов для текстового поля
            textField.layer.cornerRadius = radius
            
            // Устанавливаем текущий объект как делегат для текстового поля
            textField.delegate = self
            
            // Устанавливаем смещение базовой линии текста
            textField.defaultTextAttributes.updateValue(textPosition, forKey: NSAttributedString.Key.baselineOffset)
            
            // Устанавливаем отступ слева для текстового поля
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
            
            // Настройка и добавление плейсхолдера в текстовое поле
            let placeholderLabel = UILabel()
            placeholderLabel.text = textField.placeholder
            placeholderLabel.font = UIFont(name: "SFProDisplay-Regular", size: sizeNormalPlaceHolder)
            placeholderLabel.textColor = UIColor(red: 169/255, green: 171/255, blue: 183/255, alpha: 1)
            placeholderLabel.frame.size = CGSize(width: textField.frame.width - 32, height: 17)
            placeholderLabel.frame.origin = CGPoint(x: leftPadding, y: ((textField.frame.height - sizeNormalPlaceHolder) / 2) - placeholderAdjustment)
            
            // Присваиваем плейсхолдеру текстового поля прозрачный цвет, чтобы избежать перекрытия
            if let placeholder = textField.placeholder {
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.clear
                ]
                textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            }
            
            // Добавление плейсхолдера на текстовое поле и установка тега для последующего доступа к плейсхолдеру
            placeholderLabel.tag = 100
            textField.addSubview(placeholderLabel)
            
            // Добавляем обработчик изменений текста для поля с плейсхолдером "Номер телефона"
            if textField.placeholder == "Номер телефона" {
                textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            }
        }
    }
    
    // MARK: Блок с номером телефона
    
    // Метод formattedNumber выполняет форматирование номера телефона согласно маске
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number // Получаем чистый номер телефона без форматирования
        let mask = "+7 (***) ***-**-**" // Задаем маску для номера телефона
        
        var result = "" // Итоговая отформатированная строка номера
        var index = cleanPhoneNumber.startIndex // Индекс для обхода чистого номера
        
        // Проходим по маске и заменяем символы '*' на соответствующие цифры из чистого номера
        for ch in mask {
            if ch == "*" {
                if index < cleanPhoneNumber.endIndex {
                    result.append(cleanPhoneNumber[index])
                    index = cleanPhoneNumber.index(after: index)
                } else {
                    result.append(ch)
                }
            } else {
                result.append(ch)
            }
        }
        
        return result // Возвращаем отформатированный номер телефона согласно маске
    }
    
    // Метод textFieldDidChange обрабатывает изменения в текстовом поле и форматирует ввод номера телефона
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // Фильтруем введенный текст, оставляя только цифры
        var filteredText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Если введенный текст начинается с "7", убираем эту цифру
        if filteredText.starts(with: "7") {
            filteredText = String(filteredText.dropFirst())
        }
        
        // Ограничиваем длину текста до 10 символов
        if filteredText.count > 10 {
            filteredText = String(filteredText.prefix(10))
        }
        
        // Форматируем отфильтрованный текст с помощью метода formattedNumber
        textField.text = formattedNumber(number: filteredText)
        
        // Находим новую позицию курсора с учетом маски
        let newCursorPosition = findCursorPosition(input: textField.text ?? "", cursor: filteredText.count)
        
        // Устанавливаем новую позицию курсора
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        // Если отформатированный текст пустой, устанавливаем позицию курсора в начало
        if filteredText.isEmpty {
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: 4) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                return
            }
        }
        
        previousText = textField.text
    }
    
    // Функция findCursorPosition находит позицию курсора в тексте с учетом маски
    func findCursorPosition(input: String, cursor: Int) -> Int {
        // Задаем маску для номера телефона
        let mask = "+7 (***) ***-**-**"
        
        // Инициализируем переменную cursorPosition для отслеживания позиции курсора
        var cursorPosition = 0
        
        // Инициализируем переменную inputIndex для отслеживания позиции входного текста
        var inputIndex = 0
        
        // Проходим по каждому символу в маске
        for ch in mask {
            // Проверяем, достигли ли мы заданной позиции курсора
            if inputIndex >= cursor {
                break
            }
            
            // Увеличиваем значение cursorPosition для отслеживания позиции курсора
            cursorPosition += 1
            
            // Если текущий символ в маске является символом "*" (пропуском), то увеличиваем inputIndex
            if ch == "*" {
                inputIndex += 1
            }
        }
        
        // Возвращаем найденную позицию курсора
        return cursorPosition
    }
    
    // MARK: Проверка на правильность заполнения имейл
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: Скрытие клавиатуры
    
    // Метод для настройки жеста тапа, который будет скрывать клавиатуру
    func setupGestureToHideKeyboard(viewController: UIViewController) {
        self.viewController = viewController
        
        // Создаем объект жеста тапа
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        // Добавляем жест тапа к view контроллера
        viewController.view.addGestureRecognizer(tapGesture)
    }
    
    // Метод, вызываемый при тапе по view, чтобы скрыть клавиатуру
    @objc func hideKeyboard() {
        // Закрываем клавиатуру, прекращая редактирование
        viewController?.view.endEditing(true)
    }
    
}

