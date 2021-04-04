//
//  ImagePickerViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/03/02.
//

import UIKit
import Photos
import AVFoundation

public enum SelectMode {
    case multiple
    case single
}

public enum MediaType {
    case image
    case video
    case unsupported
    
    public func value() -> Int {
        switch self {
        case .image:
            return PHAssetMediaType.image.rawValue
        case .video:
            return PHAssetMediaType.video.rawValue
        case .unsupported:
            return PHAssetMediaType.unknown.rawValue
        }
    }
    
    init(withPHAssetMediaType type: PHAssetMediaType) {
        switch type {
        case .image:
            self = .image
        case .video:
            self = .video
        default:
            self = .unsupported
        }
    }
}

class ImagePickerViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var cropAreaView: CropAreaView!
    private var scrollView: UIScrollView!
    private var collectionView: UICollectionView!
    
    private var dataSource: PhotosDataSource!
    private var selectMode: SelectMode = .multiple

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.dataSource == nil {
            self.requestAndFetchAssets()
        }
    }
    
    private func initialize() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(tapDone))
        
        scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
        imageView = UIImageView(image: UIImage(named: "crop_img")!)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        
        cropAreaView = CropAreaView()
        view.addSubview(cropAreaView)
        cropAreaView.translatesAutoresizingMaskIntoConstraints = false
        cropAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cropAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cropAreaView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cropAreaView.heightAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: TestPhotoPickerImageCollectionViewLayout())
        collectionView.dataSource = self
        //        collectionView.delegate = self
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: ImagePickerCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func tapDone() {
        guard let image = imageView.image else { return }

        // ズームしてスクロールされた場合の座標軸をscrollViewの座標軸から変換
        let cropAreaRect = cropAreaView.convert(cropAreaView.cropAreaRect, to: scrollView)

        // imageViewのスケールを取得
        let imageViewScale = max(
            image.size.width / imageView.frame.width,
            image.size.height / imageView.frame.height)

        // imageView内のimageの座標を取得(サイズ比やスケールによって座標が違うため)
        let imageOriginInImageView = AVMakeRect(aspectRatio: image.size, insideRect: imageView.frame).origin

        // スケールと実際の画像位置の差異を補正してクロップ座標を取得
        let cropZone = CGRect(
            x: (cropAreaRect.origin.x - imageOriginInImageView.x) * imageViewScale,
            y: (cropAreaRect.origin.y - imageOriginInImageView.y) * imageViewScale,
            width: cropAreaRect.width * imageViewScale,
            height: cropAreaRect.height * imageViewScale)

        let croppedCGImage = image.cgImage?.cropping(to: cropZone)

        if let croppedCGImage = croppedCGImage {
            let croppedImage = UIImage(cgImage: croppedCGImage)
//            delegate?.didCrop(image: croppedImage)
//            imageView.image = croppedImage
            let vc = DisplayViewController()
            vc.img = croppedImage
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func requestAndFetchAssets() {
        if canAccessPhotoLib() {
            self.fetchPhotos()
        } else {
            let okAction = UIAlertAction(
                title: "許可",
                style: .default) { (_) in
                self.requestAuthorizationForPhotoAccess(authorized: self.fetchPhotos, rejected: self.openIphoneSetting)
            }

            let cancelAction = UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil)

            showDialog(
                in: self,
                okAction: okAction,
                cancelAction: cancelAction,
                title: "アクセス許可",
                message: "ライブラリにアクセスしますか？"
                )
        }
    }
    
    private func fetchPhotos() {
        let photoAssets = getAssets(allowMediaTypes: [MediaType.image])
        let imagePickerPhotoAssets = photoAssets.map { ImagePickerPhotoAsset(asset: $0) }
        dataSource = PhotosDataSource(photoAssets: imagePickerPhotoAssets)
        
        if dataSource.numberOfPhotos > 0 {
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(row: dataSource.numberOfPhotos - 1, section: 0),
                                                animated: false,
                                                scrollPosition: .bottom)
            if let photoAsset = self.dataSource.photo(atIndex: 0) {
                photoAsset.requestFullSizePhoto({ image in
                    self.imageView.image = image
                })
            }
        }
    }
    
    func getAssets(allowMediaTypes: [MediaType]) -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared, .typeiTunesSynced]
        
        fetchOptions.predicate = NSPredicate(format: "mediaType IN %@", allowMediaTypes.map( { $0.value() }))
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        guard fetchResult.count > 0 else { return [] }
        
        var photoAssets = [PHAsset]()
        fetchResult.enumerateObjects() { asset, index, _ in
            photoAssets.append(asset)
        }
        
        return photoAssets
    }
    
    func canAccessPhotoLib() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    func showDialog(in viewController: UIViewController,
                           okAction: UIAlertAction,
                           cancelAction: UIAlertAction,
                           title: String,
                           message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        viewController.present(alertController, animated: true)
    }
    
    func requestAuthorizationForPhotoAccess(authorized: @escaping () -> Void, rejected: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    authorized()
                } else {
                    rejected()
                }
            }
        }
    }
    
    func openIphoneSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}

extension ImagePickerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImagePickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let total = self.dataSource?.numberOfPhotos {
            return total
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.identifier, for: indexPath) as? ImagePickerCollectionViewCell, let photoAsset = self.dataSource.photo(atIndex: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        cell.loadView(photoAsset: photoAsset,
                      selectMode: selectMode,
                      selectedIndex: dataSource.selectedIndexOfPhoto(atIndex: indexPath.item))
        
        cell.onTapSelect = { [unowned self, unowned cell] in
            if let selectedIndex = self.dataSource.selectedIndexOfPhoto(atIndex: indexPath.item) {
                self.dataSource.unsetSeclectedForPhoto(atIndex: indexPath.item)
                cell.performSelectionAnimation(selectedIndex: nil)
                self.reloadAffectedCellByChangingSelection(changedIndex: selectedIndex)
            } else {
                self.tryToAddPhotoToSelectedList(photoIndex: indexPath.item)
            }
        }
        
        return cell
    }
    
    public func reloadAffectedCellByChangingSelection(changedIndex: Int) {
        let affectedList = self.dataSource.affectedSelectedIndexs(changedIndex: changedIndex)
        let indexPaths = affectedList.map { return IndexPath(row: $0, section: 0) }
        self.collectionView.reloadItems(at: indexPaths)
    }
    
    public func tryToAddPhotoToSelectedList(photoIndex index: Int) {
        if selectMode == .multiple {
            var canBeAdded = true
            if self.dataSource.countSelectedPhoto(byType: .image) >= 5 {
                    canBeAdded = false
                }
            if canBeAdded {
                self.dataSource.setSeletedForPhoto(atIndex: index)
                self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        } else {
            var indexPaths = [IndexPath]()
            self.dataSource.getSelectedPhotos().forEach { photo in
                guard let photoIndex = self.dataSource.index(ofPhoto: photo) else { return }
                indexPaths.append(IndexPath(row: photoIndex, section: 0))
                self.dataSource.unsetSeclectedForPhoto(atIndex: photoIndex)
            }
            
            self.dataSource.setSeletedForPhoto(atIndex: index)
            indexPaths.append(IndexPath(row: index, section: 0))
            self.collectionView.reloadItems(at: indexPaths)
        }
    }
}
