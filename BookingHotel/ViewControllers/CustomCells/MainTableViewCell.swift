//
//  MainTableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import UIKit

class MainTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var stackViewWithStar: UIStackView!
    @IBOutlet weak var viewWithPagination: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!

    // Массив изображений
        var yourImagesArray = [UIImage(named: "HotelImage"), UIImage(named: "HotelImage2"), UIImage(named: "HotelImage3"), UIImage(named: "HotelImage3")]
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            collectionView.delegate = self
            collectionView.dataSource = self
    
            
            stackViewWithStar.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 0/255, alpha: 0.2)
            stackViewWithStar.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            stackViewWithStar.isLayoutMarginsRelativeArrangement = true
            
            viewWithPagination.layer.cornerRadius = 5
            
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            // Настройки для pageControl
            pageControl.numberOfPages = yourImagesArray.count
            pageControl.currentPage = 0
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            pageControl.currentPageIndicatorTintColor = UIColor.black


            pageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
            
            let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "MyCustomCell")
            
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
        
        // MARK: UICollectionView DataSource Methods
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return yourImagesArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCell", for: indexPath) as! CollectionViewCell
            cell.imageView.image = yourImagesArray[indexPath.row]
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
