//
//  TestPhotoPickerImageCollectionViewCell.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/02/21.
//

import UIKit
import Photos

class TestPhotoPickerImageCollectionViewCell: UICollectionViewCell {
    static let scale: CGFloat = 3
    static let identifier = String(describing: TestPhotoPickerImageCollectionViewCell.self)
    
    weak var cellFilterContainer: UIView!
    weak var imageView: UIImageView!
    weak var selectButton: UIButton!
    weak var selectedIndex: UILabel!
    
    private var selectMode: TestSelectMode!
    
    public var onTapSelect = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupview() {
        contentView.clipsToBounds = true
        
        let imageView = UIImageView()
        self.imageView = imageView
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
        
        let cellFilterContainer = UIView()
        self.cellFilterContainer = cellFilterContainer
        cellFilterContainer.layer.borderColor = UIColor.blue.cgColor
        cellFilterContainer.layer.borderWidth = 2
        cellFilterContainer.isHidden = true
        
        contentView.addSubview(cellFilterContainer)
        cellFilterContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellFilterContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellFilterContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cellFilterContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellFilterContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
        
        let cellButton = UIButton()
//        self.selectButton = selectButton
        cellButton.addTarget(self, action: #selector(onTapSelects(_:)), for: .touchUpInside)
        contentView.addSubview(cellButton)
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cellButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
        
        let selectButton = UIButton()
        self.selectButton = selectButton
        self.selectButton.isUserInteractionEnabled = false
//        selectButton.addTarget(self, action: #selector(onTapSelects(_:)), for: .touchUpInside)
        self.selectButton.layer.cornerRadius = 10
        self.selectButton.layer.borderColor = UIColor.white.cgColor
        self.selectButton.layer.borderWidth = 1
        
        contentView.addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            selectButton.heightAnchor.constraint(equalToConstant: 20),
            selectButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        
        let selectedIndex = UILabel()
        self.selectedIndex = selectedIndex
        selectedIndex.font = .systemFont(ofSize: 15)
        selectedIndex.textColor = .white
        
        contentView.addSubview(selectedIndex)
        selectedIndex.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedIndex.centerXAnchor.constraint(equalTo: selectButton.centerXAnchor),
            selectedIndex.centerYAnchor.constraint(equalTo: selectButton.centerYAnchor),
        ])
    }
    
    public func loadView(photoAsset: PHAsset, selectMode: TestSelectMode, selectedIndex: Int?) {
        self.selectMode = selectMode
        
        if selectMode == .single {
            self.selectedIndex.isHidden = true
            self.selectButton.isHidden = true
//            self.editedMarkImageViewTopConstraint?.constant = 10
        }
        
        let manager: PHImageManager = PHImageManager()
        manager.requestImage(for: photoAsset,
                             targetSize: CGSize(width: self.bounds.width, height: self.bounds.height),
            contentMode: .aspectFit,
            options: nil) { (image, info) -> Void in
            self.imageView.image = image
        }
        
        
//        self.photoAsset = photoAsset

//        photoAsset.requestThumb() { image in
//            self.imageView.image = image
//        }
        
//        photoAsset.thumbChanged = { [weak self, weak photoAsset] image in
//            guard let strongSelf = self, let strongPhotoAsset = photoAsset else { return }
//            strongSelf.imageView.image = image
//            strongSelf.editedMarkImageView.isHidden = !strongPhotoAsset.isEdited()
//        }
//
//        if photoAsset.mediaType == .video {
//            self.videoInfoView.isHidden = false
//            self.videoLengthLabel.text = photoAsset.asset?.duration.stringTime
//        }
//
//        self.editedMarkImageView.isHidden = !photoAsset.isEdited()
        
        self.performSelectionAnimation(selectedIndex: selectedIndex)
    }
    
    @IBAction func onTapSelects(_ sender: Any) {
        self.onTapSelect()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.imageView.image = nil
        
//        self.photoAsset?.cancelAllRequest()
    }
    
    func performSelectionAnimation(selectedIndex: Int?) {
        if let selectedIndex = selectedIndex {
            if self.selectMode == .multiple {
                self.selectedIndex.isHidden = false
                self.selectedIndex.text = "\(selectedIndex + 1)"
                self.selectButton.backgroundColor = UIColor.blue
                self.selectButton.layer.borderColor = UIColor.white.cgColor
//            self.selectButton.layer.cornerRadius = 20
//            self.selectButton.layer.borderColor = UIColor.white.cgColor
//            self.selectButton.layer.borderWidth = 1
//            self.selectButton.backgroundColor = .blue
//                self.selectButton.setImage(UIImage(named: "check_on", in: .current, compatibleWith: nil), for: .normal)
            } else {
                self.selectedIndex.isHidden = true
                self.selectButton.layer.borderColor = UIColor.clear.cgColor
//                self.selectButton.setImage(UIImage(named: "single_check_on", in: .current, compatibleWith: nil), for: .normal)
            }
            self.cellFilterContainer.isHidden = false
        } else {
            self.selectedIndex.isHidden = true
            self.cellFilterContainer.isHidden = true
//            self.selectButton.backgroundColor = .clear
            self.selectButton.backgroundColor = UIColor.clear
//            self.selectButton.setImage(UIImage(named: "check_off", in: .current, compatibleWith: nil), for: .normal)
        }
    }
}
