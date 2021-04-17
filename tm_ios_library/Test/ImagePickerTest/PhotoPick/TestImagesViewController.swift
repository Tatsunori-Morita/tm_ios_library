//
//  TestImagesViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/02/21.
//

import UIKit
import Photos

class TestImagesViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private static let identifier = String(describing: TestImagesViewController.self)

    static func createInstance() -> TestImagesViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! TestImagesViewController
    }
    
    private var config: TestPhotoPickerConfig = TestPhotoPickerConfig()
    
    private var dataSource: PhotosDataSource! {
        didSet {
            
        }
    }
    
    @IBAction func tapButton(_ sender: Any) {
        var conf = TestPhotoPickerConfig()
        if self.config.selectMode == .single {
            conf.selectMode = .multiple
        } else {
            conf.selectMode = .single
        }
        self.config = conf
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func zoomForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        zoomRect.size.width = self.scrollView.frame.size.width  / scale
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        return zoomRect
    }
    
//    public init(config: TestPhotoPickerConfig) {
//        super.init()
//        configure()
////        super.init(nibName: nil, bundle: nil)
////        modalPresentationStyle = .fullScreen
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    func setConfig(config: TestPhotoPickerConfig) {
//        self.config = config
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.dataSource == nil {
            self.requestAndFetchAssets()
            
        }
    }
}

private extension TestImagesViewController {
    func initializeViews() {
        self.scrollView.delegate = self
        // 最大倍率・最小倍率を設定する
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.minimumZoomScale = 1.0
        self.imageView.contentMode = .scaleAspectFit
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.collectionViewLayout = TestPhotoPickerImageCollectionViewLayout()
        collectionView.register(TestPhotoPickerImageCollectionViewCell.self, forCellWithReuseIdentifier: TestPhotoPickerImageCollectionViewCell.identifier)
    }
    
    func requestAndFetchAssets() {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.fetchPhotos()
        } else {
//            let okAction = UIAlertAction(
//                title: config.strings["permission_button_ok"],
//                style: .default) { (_) in
//                Helper.requestAuthorizationForPhotoAccess(authorized: self.fetchPhotos, rejected: Helper.openIphoneSetting)
//            }
//
//            let cancelAction = UIAlertAction(
//                title: config.strings["permission_button_cancel"],
//                style: .cancel,
//                handler: nil)
//
//            Helper.showDialog(
//                in: self,
//                okAction: okAction,
//                cancelAction: cancelAction,
//                title: config.strings["permission_dialog_title"],
//                message: config.strings["permission_dialog_message"]
//            )
        }
    }
    
    func fetchPhotos() {
        let photoAssets = getAssets()
//        self.dataSource = PhotosDataSource(photoAssets: photoAssets)
        
        if self.dataSource.numberOfPhotos > 0 {
            self.collectionView.reloadData()
            self.collectionView.selectItem(at: IndexPath(row: self.dataSource.numberOfPhotos - 1, section: 0),
                                                animated: false,
                                                scrollPosition: .bottom)
        }
    }
    
    func getAssets() -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared, .typeiTunesSynced]
        
//        fetchOptions.predicate = NSPredicate(format: "mediaType IN %@", allowMediaTypes.map( { $0.value() }))
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        
        guard fetchResult.count > 0 else { return [] }
        
        var photoAssets = [PHAsset]()
        fetchResult.enumerateObjects() { asset, index, _ in
            photoAssets.append(asset)
        }
        return photoAssets
    }
}

extension TestImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let total = self.dataSource?.numberOfPhotos {
            return total
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestPhotoPickerImageCollectionViewCell.identifier, for: indexPath) as? TestPhotoPickerImageCollectionViewCell, let photoAsset = self.dataSource.photo(atIndex: indexPath.item) else {
            return UICollectionViewCell()
        }
//        let manager: PHImageManager = PHImageManager()
//        manager.requestImage(for: photoAsset,
//                             targetSize: CGSize(width: cell.bounds.width, height: cell.bounds.height),
//            contentMode: .aspectFit,
//            options: nil) { (image, info) -> Void in
//            cell.imageView.image = image
//        }
//
//        cell.performSelectionAnimation(selectedIndex: self.dataSource.selectedIndexOfPhoto(atIndex: indexPath.item))
        
//        cell.loadView(photoAsset: photoAsset,
//                      selectMode: self.config.selectMode,
//                      selectedIndex: self.dataSource.selectedIndexOfPhoto(atIndex: indexPath.item))

        
        cell.onTapSelect = { [unowned self, unowned cell] in
            if let selectedIndex = self.dataSource.selectedIndexOfPhoto(atIndex: indexPath.item) {
                self.dataSource.unsetSeclectedForPhoto(atIndex: indexPath.item)
                cell.performSelectionAnimation(selectedIndex: nil)
                self.reloadAffectedCellByChangingSelection(changedIndex: selectedIndex)
            } else {
                if self.dataSource.countSelectedPhoto(byType: .image) >= self.config.maxImage {
                    return
                }

                self.tryToAddPhotoToSelectedList(photoIndex: indexPath.item)
//                self.dataSource.setSeletedForPhoto(atIndex: indexPath.item)
//                self.collectionView.reloadItems(at: [IndexPath(row: indexPath.item, section: 0)])
//                self.updateControlBar()
            }
//            self.updateControlBar()
            
            let newSize = CGSize(width: 2000,
                                 height: 2000)
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.resizeMode = .fast
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            let manager: PHImageManager = PHImageManager()
//            manager.requestImage(for: photoAsset,
//                                 targetSize: CGSize(width: self.imageView.bounds.width, height: self.imageView.bounds.height),
//                                 contentMode: .aspectFit,
//                                 options: options) { (image, info) -> Void in
//                self.imageView.image = image
//            }
        }
        
        return cell
    }
    
    public func reloadAffectedCellByChangingSelection(changedIndex: Int) {
        let affectedList = self.dataSource.affectedSelectedIndexs(changedIndex: changedIndex)
        let indexPaths = affectedList.map { return IndexPath(row: $0, section: 0) }
        self.collectionView.reloadItems(at: indexPaths)
    }
    
    public func tryToAddPhotoToSelectedList(photoIndex index: Int) {
        if self.config.selectMode == .multiple {
//            guard let fmMediaType = self.dataSource.mediaTypeForPhoto(atIndex: index) else { return }
//
            var canBeAdded = true
//
//            switch fmMediaType {
//            case .image:
            if self.dataSource.countSelectedPhoto(byType: .image) >= self.config.maxImage {
                    canBeAdded = false
//                    let warning = FMWarningView.shared
//                    warning.message = String(format: config.strings["picker_warning_over_image_select_format"]!, self.config.maxImage)
//                    warning.showAndAutoHide()
                }
//            case .video:
//                if self.dataSource.countSelectedPhoto(byType: .video) >= self.config.maxVideo {
//                    canBeAdded = false
//                    let warning = FMWarningView.shared
//                    warning.message = String(format: config.strings["picker_warning_over_video_select_format"]!, self.config.maxVideo)
//                    warning.showAndAutoHide()
//                }
//            case .unsupported:
//                break
//            }
//
            if canBeAdded {
                self.dataSource.setSeletedForPhoto(atIndex: index)
                self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
//                self.updateControlBar()
            }
        } else {  // single selection mode
            var indexPaths = [IndexPath]()
            self.dataSource.getSelectedPhotos().forEach { photo in
                guard let photoIndex = self.dataSource.index(ofPhoto: photo) else { return }
                indexPaths.append(IndexPath(row: photoIndex, section: 0))
                self.dataSource.unsetSeclectedForPhoto(atIndex: photoIndex)
            }
            
            self.dataSource.setSeletedForPhoto(atIndex: index)
            indexPaths.append(IndexPath(row: index, section: 0))
            self.collectionView.reloadItems(at: indexPaths)
//            self.updateControlBar()
        }
    }
}

extension TestImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

