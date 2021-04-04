//
//  TestImagePickerViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/02/20.
//

import UIKit
import FMPhotoPicker
//import CropViewController
//import DKImagePickerController

class TestImagePickerViewController: UIViewController {
    
    var baseView: UIView?
//    var cropViewController: CropViewController?
    var imageView: UIImageView?
    var scroll: TestScrollView!
    
    private var maxImage: Int = 5
    private var maxVideo: Int = 5


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        scroll = TestScrollView(image: UIImage(named: "crop_img")!)
//        scroll.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        scroll.backgroundColor = .blue
//        self.view.addSubview(scroll)

        
        let btn = UIButton(frame: CGRect(x: 0, y: 450, width: self.view.bounds.width, height: 100))
        btn.setTitle("Button", for: .normal)
        btn.backgroundColor = .blue
        btn.titleLabel?.textColor = .white
        btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
        self.view.addSubview(btn)
        
//
//        imageView = UIImageView(frame: CGRect(x: 0, y: 600, width: view.bounds.width, height: 300))
//        imageView?.backgroundColor = .red
//        view.addSubview(imageView!)
//
//        baseView = UIView(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 300))
//        baseView!.backgroundColor = .blue
//        self.view.addSubview(baseView!)
////
////
//        cropViewController = CropViewController(image: UIImage(named: "crop_img")!)
//        let testBtn = cropViewController?.toolbar.doneIconButton
////        testBtn?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
//        testBtn!.center = view.center
//        testBtn!.setTitle("Button", for: .normal)
//        testBtn!.backgroundColor = .yellow
//        testBtn?.titleLabel?.textColor = .white
//        testBtn!.center = self.view.center
//        self.view.addSubview(testBtn!)
        
//        cropViewController!.view.frame = baseView!.frame
//        baseView!.addSubview(cropViewController!.view)
//        cropViewController!.delegate = self
//        present(cropViewController!, animated: true, completion: nil)
//
        
//        let testBtn = cropViewController?.toolbar.doneIconButton
//        let tool = cropViewController?.toolbar
//        tool?.isHidden = true
////        testBtn!.frame = CGRect(x: 100, y: 0, width: 0, height: 0)
//
//        testBtn?.setImage(nil, for: .normal)
//        testBtn!.setTitle("次へ", for: .normal)
//        testBtn!.backgroundColor = .yellow
//        testBtn!.titleLabel?.textColor = .white
//        imageView!.addSubview(testBtn!)
//        testBtn!.translatesAutoresizingMaskIntoConstraints = false
////        testBtn!.leadingAnchor.constraint(equalTo: baseView!.leadingAnchor, constant: 100).isActive = true
////        testBtn!.trailingAnchor.constraint(equalTo: baseView!.trailingAnchor).isActive = true
//        testBtn!.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        testBtn!.heightAnchor.constraint(equalToConstant: 100).isActive = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let testBtn = cropViewController?.toolbar.cancelIconButton
//        testBtn!.frame = CGRect(x: 100, y: 0, width: 0, height: 0)
    }
    
    @objc func tap() {
        var config = FMPhotoPickerConfig()
        config.availableCrops = [
            FMCrop.ratioSquare,
            FMCrop.ratioCustom,
            FMCrop.ratio4x3,
            FMCrop.ratio16x9,
            FMCrop.ratio9x16,
            FMCrop.ratioOrigin,
        ]
        config.strings["editor_button_done"] = "次へ"
        let vc = FMImageEditorViewController(config: config, sourceImage: UIImage(named: "crop_img")!)
        
//        vc.delegate = self
        
        self.present(vc, animated: true)
        
//        print(cropViewController?.image.scale)
//        let img = cropViewController?.image.resize(size: (cropViewController?.imageCropFrame.size)!)
//        cropViewController?.toolbar.doneIconButton
//        imageView?.image = cropViewController?.image.resize(size: CGSize(width: 50, height: 50))
//        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//        var config = FMPhotoPickerConfig()
//        config.selectMode = .multiple
//        config.maxImage = 5
//        config.availableFilters = nil
//        config.availableCrops = nil

//        let picker = FMPhotoPickerViewController(config: config)
//        picker.delegate = self
//        self.present(picker, animated: true)
        
        
//        let vc = TestImagesViewController.createInstance()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        
//        removeAllSubviews(parentView: baseView!)
//        let cropViewController = CropViewController(image: UIImage(named: "number_circle")!)
//
//        //AspectRatioのサイズをimageViewのサイズに合わせる。
////        cropViewController.customAspectRatio = imageView.frame.size
//
//        //今回は使わない、余計なボタン等を非表示にする。
//        cropViewController.aspectRatioPickerButtonHidden = true
//        cropViewController.resetAspectRatioEnabled = false
//        cropViewController.rotateButtonsHidden = true
//        cropViewController.doneButtonHidden = true
//        cropViewController.cancelButtonHidden = true
//        cropViewController.resetButtonHidden = true
//
//        //cropBoxのサイズを固定する。
////        cropViewController.cropView.cropBoxResizeEnabled = false
//        cropViewController.view.frame = baseView!.frame
//        baseView!.addSubview(cropViewController.view)
        
//        cropViewController.delegate = self
//        present(cropViewController, animated: true, completion: nil)
    }
    
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        //加工した画像が取得できる
//        imageView?.image = image
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
//        // キャンセル時
//        cropViewController.dismiss(animated: true, completion: nil)
//    }

    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

extension UIButton {
    func copy() -> UIButton {
        return self
    }
}

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}


extension TestImagePickerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scroll.imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        matchForegroundToBackground()
//        translucencyView.safetyHide()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        matchForegroundToBackground()
//        translucencyView.safetyHide()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        translucencyView.scheduleShowing()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            translucencyView.scheduleShowing()
//        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        translucencyView.scheduleShowing()
    }
}
