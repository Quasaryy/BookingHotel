//
//  MainTableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import UIKit

class MainTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Массив изображений
    var imageUrls: [String] = []
    
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hotelName.numberOfLines = 0
        hotelName.lineBreakMode = .byWordWrapping
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        stackViewWithStar.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 0/255, alpha: 0.2)
        stackViewWithStar.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackViewWithStar.isLayoutMarginsRelativeArrangement = true
        stackViewWithStar.layer.cornerRadius = 5
        
        viewWithPagination.layer.cornerRadius = 5
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Настройки для pageControl
        pageControl.numberOfPages = imageUrls.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
        
        pageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "СollectionViewMainCell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
        
        collectionView.layer.cornerRadius = 15
        
        collectionView.reloadData()
        
        self.backgroundColor = UIColor.clear // Задаем прозрачный фон для ячейки
        self.contentView.backgroundColor = .white
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
    }
    
    
    @IBAction func hotelAdressButttonTapped(_ sender: UIButton) {
        Logger.log("Кнопка адреса отеля была нажата, но ничего не происходит согласно тех заданию")
    }
    
    
    // MARK: UICollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "СollectionViewMainCell", for: indexPath) as! CollectionViewCell
        
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    @objc func changePage(sender: UIPageControl) {
        let x = CGFloat(sender.currentPage) * collectionView.frame.size.width
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}

// MARK: UIScrollViewDelegate methods
extension MainTableViewCell {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        pageControl.currentPage = Int(collectionView.contentOffset.x / pageWidth)
    }
}
