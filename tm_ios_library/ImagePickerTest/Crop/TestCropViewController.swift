//
//  TestCropViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/03/01.
//

import UIKit
import AVFoundation

class TestCropViewController: UIViewController {
    
    static let identifier = "TestCropViewController"
    
    var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 2
        }
    }
    
    var imageView: UIImageView!
    
//    @IBOutlet weak var view_crop: UIView! {
//        didSet {
//            view_crop.layer.cornerRadius = 5
//            view_crop.layer.borderWidth = 3
//            view_crop.layer.borderColor = UIColor.red.cgColor
//            view_crop.backgroundColor = .clear
//        }
//    }
  
    var cropAreaView: CropAreaView!
    
    
    static func createInstance() -> TestCropViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! TestCropViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(tapDone))
        
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        imageView = UIImageView(image: UIImage(named: "crop_img")!)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
        cropAreaView = CropAreaView()
        view.addSubview(cropAreaView)
        cropAreaView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cropAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cropAreaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cropAreaView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cropAreaView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
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
    
//    @IBAction func button_crop_clicked(_ sender: Any) {
//        guard let imageToCrop = imageView.image else {
//            return
//        }
//
//        let cropRect = CGRect(x: view_crop.frame.origin.x - imageView.realImageRect().origin.x, y: view_crop.frame.origin.y - imageView.realImageRect().origin.y, width: view_crop.frame.width, height: view_crop.frame.height)
//
//        let croppedImage = ImageCropHandler.sharedInstance.cropImage(imageToCrop, toRect: cropRect, viewWidth: imageView.frame.width, viewHeight: imageView.frame.height)
//        imageView.image = croppedImage
//        scrollView.zoomScale = 1
//    }
}

extension TestCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension UIImageView {
    func realImageRect() -> CGRect {
        let imageViewSize = self.frame.size
        let imgSize = self.image?.size
        
        guard let imageSize = imgSize else {
            return CGRect.zero
        }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        imageRect.origin.x += self.frame.origin.x
        imageRect.origin.y += self.frame.origin.y
        
        return imageRect
    }
}
