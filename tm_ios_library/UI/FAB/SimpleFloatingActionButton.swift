//
//  SimpleFloatingActionButton.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/14.
//

import UIKit

protocol SimpleFloatingActionButtonDelegate {
    func onTapped()
    func didOpen()
    func didClose()
}

@IBDesignable
class SimpleFloatingActionButton: UIView {
    
    private let frontView = UIView(frame: .zero)
    private let overlayView = UIView(frame: .zero)
    
    private let plusIconView: PlusIconView = {
        let view = PlusIconView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var closed: Bool = true
    
    private var overlayViewDidCompleteOpenAnimation: Bool = true
    
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
    
    @IBInspectable
    public var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.3)

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
    
    @objc private func onTapped() {
        delegate?.onTapped()
        toggle()
    }
    
    private func toggle() {
        if closed {
            open()
        } else {
            close()
        }
    }
    
    private func open() {
        let animationGrooup = DispatchGroup()
        
        setOverlayView()
        self.superview?.insertSubview(overlayView, aboveSubview: self)
        self.superview?.bringSubviewToFront(self)
        
        overlayViewDidCompleteOpenAnimation = false
        animationGrooup.enter()
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.3,
                       options: UIView.AnimationOptions(), animations: { () -> Void in
                        self.transform = CGAffineTransform(rotationAngle: (-45 / 180.0 * CGFloat.pi))
                        self.overlayView.alpha = 1
        }, completion: {(f) -> Void in
            self.overlayViewDidCompleteOpenAnimation = true
            animationGrooup.leave()
        })
        
        animationGrooup.notify(queue: .main) {
            self.delegate?.didOpen()
        }
        
        closed = false
    }
    
    private func close() {
        let animationGrooup = DispatchGroup()
        
        animationGrooup.enter()
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: UIView.AnimationOptions(), animations: { () -> Void in
                        self.transform = CGAffineTransform(rotationAngle: (0 / 180.0 * CGFloat.pi))
                        self.overlayView.alpha = 0
        }, completion: {(f) -> Void in
            if self.overlayViewDidCompleteOpenAnimation {
                self.overlayView.removeFromSuperview()
            }
            animationGrooup.leave()
        })
        
        animationGrooup.notify(queue: .main) {
            self.delegate?.didClose()
        }
        
        closed = true
    }
    
    private func setOverlayView() {
        if let superview = superview {
            overlayView.frame = CGRect(
                x: 0, y: 0,
                width: superview.bounds.width,
                height: superview.bounds.height
            )
        }
        overlayView.backgroundColor = overlayColor
        overlayView.alpha = 0
        overlayView.isUserInteractionEnabled = true
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
