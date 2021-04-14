//
//  FlexibleHeightImageViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/10.
//

import UIKit

class SampleFlexibleHeightImageViewController: UIViewController {
    
    public static let identifier = String(describing: SampleFlexibleHeightImageViewController.self)
        
    
    static func createInstance() -> SampleFlexibleHeightImageViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! SampleFlexibleHeightImageViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let imageView = FlexibleHeightImageView(frame: .zero)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "monky_img")

        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
}
