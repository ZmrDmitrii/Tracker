//
//  TrackerCollectionViewDataSource.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 10/12/24.
//

import UIKit

final class TrackerCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var categories: [TrackerCategory]
    
    init(categories: [TrackerCategory]) {
        self.categories = categories
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = categories[section]
        return category.trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}
