//
//  ScrollViewManager.swift
//  BookingHotel
//
//  Created by Yury on 12/09/2023.
//

import Foundation
import UIKit

class ScrollViewManager: NSObject {
    
    // MARK: - Properties
    
    // Синглтон для доступа к менеджеру
    static let shared = ScrollViewManager()
    
    // Слабая ссылка на объект UIScrollView
    private weak var scrollView: UIScrollView?
    
    // Слабая ссылка на объект UIViewController
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private override init() {}
    
    deinit {
        // Удаляем текущий объект как наблюдателя за всеми уведомлениями, чтобы избежать утечек памяти и не вызывать несуществующие методы после освобождения объекта из памяти
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Scroll view delegate

extension ScrollViewManager: UIScrollViewDelegate {
    
    // Метод для настройки скрытия клавиатуры при скролле
    func setupToHideKeyboardOnScroll(scrollView: UIScrollView, viewController: UIViewController) {
        // Устанавливаем scrollView и viewController, чтобы иметь к ним доступ в других методах
        self.scrollView = scrollView
        self.viewController = viewController
        
        // Устанавливаем текущий объект (ScrollViewManager) как делегат scrollView
        scrollView.delegate = self
        
        // Добавляем наблюдателей для уведомлений о появлении и скрытии клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // При начале перетаскивания содержимого scrollView (dragging) прекращаем редактирование, чтобы скрыть клавиатуру
        viewController?.view.endEditing(true)
    }
    
    // Метод, вызываемый перед появлением клавиатуры
    @objc private func keyboardWillShow(notification: NSNotification) {
        // Получаем информацию из уведомления, включая размер клавиатуры
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        // Устанавливаем отступы для scrollView так, чтобы клавиатура не перекрывала содержимое
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    // Метод, вызываемый перед скрытием клавиатуры
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Устанавливаем нулевые отступы для scrollView, возвращая его в исходное состояние
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
}

// Расширение для UIViewController чтобы добавить метод hideKeyboard
extension UIViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
