//
//  DisplayViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/03/01.
//

import UIKit

class DisplayViewController: UIViewController {
    
    var img: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFit
        imageView.image = img
        view.addSubview(imageView)
    }
}
