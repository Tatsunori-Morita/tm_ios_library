//
//  SimpleFloatingActionButton.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/14.
//

import UIKit

protocol SimpleFloatingActionButtonDelegate {
    func onTapped()
}

@IBDesignable
class SimpleFloatingActionButton: UIView {
    
    private let frontView = UIView(frame: .zero)
    
    private let plusIconView: PlusIconView = {
        let view = PlusIconView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    public var delegate: SimpleFloatingActionButtonDelegate?

    @IBInspectable
    public var frontColor: UIColor = UIColor.init(hex: "ED6317", alpha: 1.0) {
        didSet {
            frontView.backgroundColor = frontColor
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize = CGSize(width: 0.0, height: 2.0) {
        didSet {
            frontView.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor = UIColor.black {
        didSet {
            frontView.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float = 0.6 {
        didSet {
            frontView.layer.shadowOpacity = shadowOpacity
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frontView.layer.cornerRadius = frame.size.width / 2
        frontView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        frontView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        frontView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        frontView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        plusIconView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        plusIconView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        plusIconView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        plusIconView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    public func initialize() {
        backgroundColor = .clear
        frontView.backgroundColor = frontColor
        frontView.layer.shadowOffset = shadowOffset
        frontView.layer.shadowColor = shadowColor.cgColor
        frontView.layer.shadowOpacity = shadowOpacity
        
        addSubview(frontView)
        addSubview(plusIconView)
        frontView.translatesAutoresizingMaskIntoConstraints = false
        plusIconView.translatesAutoresizingMaskIntoConstraints = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        frontView.addGestureRecognizer(gesture)
    }
    
    @objc func onTapped() {
        delegate?.onTapped()
    }
}

fileprivate class PlusIconView: UIView {
    override func draw(_ rect: CGRect) {
        let verticalPath = UIBezierPath();
        verticalPath.move(to: CGPoint(x: rect.midX, y: rect.maxY / 3));
        verticalPath.addLine(to: CGPoint(x: rect.midX, y: (rect.maxY * 2) / 3));
        verticalPath.close()
        UIColor.white.setStroke()
        verticalPath.lineWidth = 2
        verticalPath.stroke();
        
        let horizontalPath = UIBezierPath();
        horizontalPath.move(to: CGPoint(x: rect.maxX / 3, y: rect.midY));
        horizontalPath.addLine(to: CGPoint(x: (rect.maxX * 2) / 3, y: rect.midY));
        horizontalPath.close()
        UIColor.white.setStroke()
        horizontalPath.lineWidth = 2
        horizontalPath.stroke();
    }
}
