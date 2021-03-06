//
//  MyHolidaysViewCell.swift
//  Bodabi
//
//  Created by 이혜진 on 2019. 1. 25..
//  Copyright © 2019년 LeeHyeJin. All rights reserved.
//

import UIKit

class MyHolidaysViewCell: UITableViewCell {
    
    // MARK: - IBOutlet

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Property
    
    public var holidays: [Holiday]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    struct Const {
        static let sectionInsetLength: CGFloat = 15.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Initialization
    
    private func initCollectionView() {
        collectionView.dataSource = self
        
        let cells = [HolidayViewCell.self, MyHolidayInputViewCell.self]
        collectionView.register(cells)
    }
}

// MARK: - UICollectionViewDataSource

extension MyHolidaysViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return holidays?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(HolidayViewCell.self, for: indexPath)
        cell.holiday = holidays?[indexPath.row]
        return cell
    }
}
