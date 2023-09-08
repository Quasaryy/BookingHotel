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

class SliderManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static let shared = SliderManager()
    
    // Список URL-адресов изображений
    var imageUrls: [String] = []
    
    // Делагат
    weak var delegate: SliderManagerDelegate?
    
    // Текущая коллекция изображений, используемоя слайдером
    weak var currentCollectionView: UICollectionView?
    
    // Элемент управления UIPageControl для отображения текущей страницы слайдера
    weak var currentPageControl: UIPageControl?
    
}

// MARK: - Methods

extension SliderManager {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "СollectionViewMainCell", for: indexPath) as! CollectionViewCell
        
        // Проверка наличия URL-адресов
        guard !imageUrls.isEmpty else {
            return cell
        }
        
        // Загрузка и установка изображения из URL
        let urlStr = imageUrls[indexPath.row]
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    // Метод для изменения страницы при нажатии на UIPageControl
    @objc func changePage(sender: UIPageControl) {
        guard let collectionView = currentCollectionView else { return }
        changePage(sender: sender, collectionView: collectionView)
    }
    
    // Метод реагирующий на изменение выбранной страницы в UIPageControl
    func changePage(sender: UIPageControl, collectionView: UICollectionView) {
        // Рассчитываем новую позицию прокрутки, умножая текущую выбранную страницу на ширину ячейки коллекции.
        let x = CGFloat(sender.currentPage) * collectionView.frame.size.width
        
        // Устанавливаем новую позицию прокрутки для коллекции, создавая CGPoint с новым значением x и текущим значением y (которое остается 0, так как прокрутка горизонтальная)
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    
    // MARK: Конфигурируем слайдер
    
    func configureSlider(for cell: MainTableViewCell) {
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.pageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
        
        self.currentCollectionView = cell.collectionView
        self.currentPageControl = cell.pageControl
        
        cell.collectionView.reloadData()
    }
}
