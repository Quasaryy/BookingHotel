//
//  CustomPageControl.swift
//  BookingHotel
//
//  Created by Yury on 14/09/2023.
//

import UIKit

class CustomPageControl: UIPageControl {
    
    // Массив для хранения вью-точек
    private var dotViews: [UIView] = []
    
    // Размер и расстояние между точками
    private let dotSize: CGFloat = 7.0
    private let dotSpacing: CGFloat = 5.0
    var currentButtonColor: UIColor = .black // Цвет активной кнопки
    private let originalDotColor = UIColor.gray // Цвет кнопок и применение альфа канала к этому цвету

    
    // Бекграунд для вью-точек
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    // Константы, используемые в классе
    private struct Constants {
        static let cornerRadius: CGFloat = 5.0
        static let containerInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        static let maxAlpha: CGFloat = 1
        static let minAlpha: CGFloat = 0.2
     }
    
    // Переопределение числа страниц
    override var numberOfPages: Int {
        didSet {
            setupDotViews()
        }
    }
    
    // Переопределение текущей страницы
    override var currentPage: Int {
        didSet {
            updateDotColors()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPageControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPageControl()
    }
    
    // Скрываем оригинальный пейдж контрол
    private func setupPageControl() {
        self.pageIndicatorTintColor = .clear
        self.currentPageIndicatorTintColor = .clear
    }
    
    // Создание и настройка вью-точек
    private func setupDotViews() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews = []
        
        addSubview(backgroundView)
        
        for _ in 0..<numberOfPages {
            let dotView = UIView()
            dotView.layer.cornerRadius = dotSize / 2
            backgroundView.addSubview(dotView)
            dotViews.append(dotView)
        }
        updateDotColors()
        setNeedsLayout()
    }
    
    // Обновление цветов вью-точек и их прозрачности
    private func updateDotColors() {
        for (index, dotView) in dotViews.enumerated() {
            let alpha: CGFloat
            if index == currentPage {
                alpha = Constants.maxAlpha
                dotView.backgroundColor = currentButtonColor
            } else {
                let distanceToFirst = index
                // Рассчитываем прозрачность в зависимости от расстояния до первой точки
                alpha = Constants.maxAlpha - CGFloat(distanceToFirst) * (Constants.maxAlpha - Constants.minAlpha) / CGFloat(numberOfPages - 1)
                dotView.backgroundColor = originalDotColor
            }
            dotView.alpha = alpha
            dotView.frame.size = CGSize(width: dotSize, height: dotSize) // Установка размера кнопки
        }
    }

    // Распологаем вью-точеки и бекграунд
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalWidth = CGFloat(numberOfPages) * dotSize + CGFloat(max(0, numberOfPages - 1)) * dotSpacing
        let startX = (bounds.width - totalWidth) / 2
        
        backgroundView.frame = CGRect(x: startX - Constants.containerInset.left,
                                      y: (bounds.height - dotSize) / 2 - Constants.containerInset.top,
                                      width: totalWidth + Constants.containerInset.left + Constants.containerInset.right,
                                      height: dotSize + Constants.containerInset.top + Constants.containerInset.bottom)
        
        for (index, dotView) in dotViews.enumerated() {
            let x = startX + CGFloat(index) * (dotSize + dotSpacing)
            dotView.frame = CGRect(x: x - (startX - Constants.containerInset.left),
                                   y: Constants.containerInset.top,
                                   width: dotSize,
                                   height: dotSize)
        }
    }
}

