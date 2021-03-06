//
//  FlexibleHeightImageView.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/10.
//

import UIKit

class FlexibleHeightImageView: UIView {
    
    private var imageView = UIImageView()
    
    @IBInspectable
    public var image: UIImage? {
        didSet {
            imageView.image = image
            updateImageViewConstraints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let img = image {
            let height = self.frame.size.width * (img.size.height / img.size.width)
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    private func updateImageViewConstraints() {
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
