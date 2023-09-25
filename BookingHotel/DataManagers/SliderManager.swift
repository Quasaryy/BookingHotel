//
//  SliderManager.swift
//  BookingHotel
//
//  Created by Yury on 08/09/2023.
//

import UIKit

protocol SliderManagerDelegate: AnyObject {
    func imageUrls(for sliderManager: SliderManager) -> [String]
}

protocol  SliderImageViewCell {
    var imageView: UIImageView! { get }
}

protocol ConfigurableCell {
    var collectionView: UICollectionView! { get set }
    var pageControl: CustomPageControl! { get set }
}

class SliderManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static let shared = SliderManager()
    
    // Список URL-адресов изображений
    var imageUrls: [String] = []
    
    // Делагат
    weak var delegate: SliderManagerDelegate?
    
    // Текущая коллекция изображений для слайдера
    weak var currentCollectionView: UICollectionView?
    
    // Элемент управления UIPageControl для отображения текущей страницы слайдера
    weak var currentPageControl: CustomPageControl?
    
}

// MARK: - Methods

extension SliderManager {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "СollectionViewCell", for: indexPath) as? UICollectionViewCell & SliderImageViewCell else {
                fatalError("Не удалось создать ячейку, соответствующую протоколу SliderImageViewCell")
            }
        
        // Закругление углов для первой и последней ячейки
        if indexPath.row == 0 {
            cell.imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == imageUrls.count - 1 {
            cell.imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.imageView.layer.maskedCorners = []
        }
        
        UtilityManager.shared.cornerRadius(for: cell.imageView, radius: 15)
        
        // Проверка наличия URL-адресов
        guard !imageUrls.isEmpty else {
            return cell
        }
        
        // Загрузка и установка изображения из URL
        let urlStr = imageUrls[indexPath.row]
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    Logger.log("Ошибка загрузки изображения: \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                } else {
                    Logger.log("Не удалось загрузить изображение")
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(named: "noImage")
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // MARK: UIScrollViewDelegate
    
    // Метод вызывается при окончании декелерации скролла, обновляя индикатор текущей страницы в UIPageControl.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        // Получаем ширину одной страницы (или ячейки) в collectionView
        let pageWidth = collectionView.frame.size.width
        
        // Вычисляем текущую страницу на основе горизонтального смещения collectionView делённое на ширину страницы.
        let currentPage = Int(collectionView.contentOffset.x / pageWidth)
        
        // Находим pageControl и устанавливаем текущую страницу
        currentPageControl?.currentPage = currentPage
    }
    
    // MARK: Page Control
    
    @objc func pageControlDidChange(sender: UIPageControl) {
        guard let collectionView = currentCollectionView else { return }
        changePage(sender: sender, collectionView: collectionView)
        
        // Устанавливаем currentPage для кастомного pageControl
        currentPageControl?.currentPage = sender.currentPage
    }
    
    // Метод реагирующий на изменение выбранной страницы в UIPageControl
    func changePage(sender: UIPageControl, collectionView: UICollectionView) {
        // Рассчитываем новую позицию прокрутки, умножая текущую выбранную страницу на ширину ячейки коллекции.
        let x = CGFloat(sender.currentPage) * collectionView.frame.size.width
        
        // Устанавливаем новую позицию прокрутки для коллекции, создавая CGPoint с новым значением x и текущим значением y (которое остается 0, так как прокрутка горизонтальная)
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    // MARK: Конфигурируем слайдер
    
    func configureSlider<T: ConfigurableCell>(for cell: T) {
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.pageControl.addTarget(self, action: #selector(pageControlDidChange(sender:)), for: .valueChanged)
            self.currentCollectionView = cell.collectionView
            self.currentPageControl = cell.pageControl
            cell.collectionView.reloadData()
        }

}
