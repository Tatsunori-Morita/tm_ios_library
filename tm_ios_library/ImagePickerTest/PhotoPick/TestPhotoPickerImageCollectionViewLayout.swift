//
//  TestPhotoPickerImageCollectionViewLayout.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/02/21.
//

import UIKit

class TestPhotoPickerImageCollectionViewLayout: UICollectionViewFlowLayout {
    let numberOfColumns: CGFloat = 3
    let padding: CGFloat = 1
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = self.padding
        self.minimumLineSpacing = self.padding
        let itemSizeW = (UIScreen.main.bounds.size.width - ((self.numberOfColumns - 1) * self.padding)) / numberOfColumns
        self.itemSize = CGSize(width: itemSizeW, height: itemSizeW)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
