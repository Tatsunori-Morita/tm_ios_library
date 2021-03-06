//
//  PhotoDataSource.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/02/21.
//

import Foundation
import Photos

class PhotosDataSource {
    public var photoAssets: [ImagePickerPhotoAsset] = []
    private var selectedPhotoIndexes: [Int]
    
    init(photoAssets: [ImagePickerPhotoAsset]) {
        self.photoAssets = photoAssets
        self.selectedPhotoIndexes = []
    }
    
    public func setSeletedForPhoto(atIndex index: Int) {
        if self.selectedPhotoIndexes.firstIndex(where: { $0 == index }) == nil {
            self.selectedPhotoIndexes.append(index)
        }
    }
    
    public func unsetSeclectedForPhoto(atIndex index: Int) {
        if let indexInSelectedIndex = self.selectedPhotoIndexes.firstIndex(where: { $0 == index }) {
            self.selectedPhotoIndexes.remove(at: indexInSelectedIndex)
        }
    }
    
    public func selectedIndexOfPhoto(atIndex index: Int) -> Int? {
        return self.selectedPhotoIndexes.firstIndex(where: { $0 == index })
    }
    
    public func numberOfSelectedPhoto() -> Int {
        return self.selectedPhotoIndexes.count
    }
    
//    public func mediaTypeForPhoto(atIndex index: Int) -> TestMediaType? {
//        return self.photo(atIndex: index)?.mediaType
//    }
//
    public func countSelectedPhoto(byType: TestMediaType) -> Int {
        return self.getSelectedPhotos().count
    }
    
    public func affectedSelectedIndexs(changedIndex: Int) -> [Int] {
        return Array(self.selectedPhotoIndexes[changedIndex...])
    }

    public func getSelectedPhotos() -> [ImagePickerPhotoAsset] {
        var result = [ImagePickerPhotoAsset]()
        self.selectedPhotoIndexes.forEach {
            if let photo = self.photo(atIndex: $0) {
                result.append(photo)
            }
        }
        return result
    }
    
    public var numberOfPhotos: Int {
        return self.photoAssets.count
    }
    
    public func photo(atIndex index: Int) -> ImagePickerPhotoAsset? {
        guard index < self.photoAssets.count, index >= 0 else { return nil }
        return self.photoAssets[index]
    }
    
    public func index(ofPhoto photo: ImagePickerPhotoAsset) -> Int? {
        return self.photoAssets.firstIndex(where: { $0 === photo })
    }
    
    public func contains(photo: ImagePickerPhotoAsset) -> Bool {
        return self.index(ofPhoto: photo) != nil
    }
    
    public func delete(photo: ImagePickerPhotoAsset) {
        if let index = self.index(ofPhoto: photo) {
            self.photoAssets.remove(at: index)
        }
    }
}
