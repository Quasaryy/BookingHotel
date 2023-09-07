//
//  MainTableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import UIKit

// Основной класс для представления ячейки в таблице
class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    // Массив URL строк для загрузки изображений
    var imageUrls: [String] = []
    
    // Создаем новый объект CAShapeLayer, который будет служить маской для слоя.
    let maskLayer = CAShapeLayer()
    
    
    // MARK: - IB Outlets
    
    // Аутлеты для различных UI элементов
    @IBOutlet weak var hotelAdress: UIButton!
    @IBOutlet weak var priceFor: UILabel!
    @IBOutlet weak var minimalPrice: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var stackViewWithStar: UIStackView!
    @IBOutlet weak var viewWithPagination: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - awakeFromNib
    
    // Метод вызывается после загрузки вью из XIB/Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Установка делегата и источника данных для collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Настройка вида стек вью с оценкой отеля
        stackViewWithStar.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 0/255, alpha: 0.2)
        stackViewWithStar.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackViewWithStar.isLayoutMarginsRelativeArrangement = true
        stackViewWithStar.layer.cornerRadius = 5
        
        // Настройка вида для пагинации
        viewWithPagination.layer.cornerRadius = 5
        
        
        // Настройка pageControl
        pageControl.numberOfPages = imageUrls.count
        pageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
        
        // Регистрация XIB для collectionView
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "СollectionViewMainCell")
        
        // Скрытие горизонтального индикатора прокрутки
        collectionView.showsHorizontalScrollIndicator = false
        
        // Округление углов
        collectionView.layer.cornerRadius = 15
        
        // Настройка вида ячейки
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = .white
        
        // Устанавливаем созданный CAShapeLayer как маску для текущего слоя.
        self.layer.mask = maskLayer
    }
    
    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Закругляем углы ячейки только снизу.
        maskLayer.path = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: [.bottomLeft, .bottomRight],
                                      cornerRadii: CGSize(width: 15, height: 15)).cgPath
    }
    
    
    // MARK: - IB Actions
    
    // Метод, вызываемый при нажатии на кнопку адреса отеля
    @IBAction func hotelAdressButttonTapped(_ sender: UIButton) {
        Logger.log("Кнопка \"Адреса отеля\" была нажата, но ничего не происходит согласно тех заданию")
    }
}

// MARK:  - UICollectionView

// Расширение для поддержки протоколов UICollectionView
extension MainTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionView DataSource Methods
    
    // Возвращение количества элементов в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    // Настройка ячейки коллекции
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "СollectionViewMainCell", for: indexPath) as! CollectionViewCell
        
        // Загрузка и установка изображения из URL
        let urlStr = imageUrls[indexPath.row]
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout Methods
    
    // Определение размера элемента
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // Метод для изменения текущей страницы при нажатии на pageControl
    @objc func changePage(sender: UIPageControl) {
        let x = CGFloat(sender.currentPage) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}

// MARK: - UIScrollViewDelegate methods

extension MainTableViewCell {
    
    // Чтобы индикатор pageControl соответствовал текущей отображаемой странице в collectionView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Получаем ширину одной страницы (или ячейки) в collectionView
        let pageWidth = collectionView.frame.size.width
        // Вычисляем текущую страницу на основе горизонтального смещения collectionView делённое на ширину страницы.
        pageControl.currentPage = Int(collectionView.contentOffset.x / pageWidth)
    }
}
