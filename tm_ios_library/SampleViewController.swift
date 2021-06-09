//
//  SampleViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/06/05.
//

import UIKit

class SampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let originImage = UIImage(named: "arrow")
        let cgImage = originImage?.cgImage
        
        // 反転比較用のオリジナル画像
        let rightArrowImageView = UIImageView(frame: CGRect(x: 0, y: 150, width: 50, height: 50))
        rightArrowImageView.center.x = view.center.x
        rightArrowImageView.image = originImage
        view.addSubview(rightArrowImageView)
        
        // オリジナル画像を反転し、左向き矢印にする
        let leftArrowImage = UIImageView(frame: CGRect(
                                            x: rightArrowImageView.frame.origin.x,
                                            y: rightArrowImageView.frame.origin.y + 100,
                                            width: 50, height: 50))
        leftArrowImage.image = UIImage(
            cgImage: cgImage!,
            scale: originImage!.scale,
            orientation: UIImage.Orientation.down)
        view.addSubview(leftArrowImage)
    }
}
