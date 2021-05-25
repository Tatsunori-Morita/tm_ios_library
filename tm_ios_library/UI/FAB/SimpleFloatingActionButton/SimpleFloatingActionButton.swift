//
//  SimpleFloatingActionButton.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/14.
//

import UIKit

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
    
    public var delegate: SimpleFloatingActionButtonDelegate?
    
    private var closed: Bool = true
    
    private var overlayViewDidCompleteOpenAnimation: Bool = true
    
    private var size: CGFloat = 63
    
    private var items: [SimpleFloatingActionButtonItem] = []

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
    
    // MARK: - Initialize
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        initialize()
    }

    public init(size: CGFloat) {
        self.size = size
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        size = min(frame.size.width, frame.size.height)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        size = min(frame.size.width, frame.size.height)
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frontView.layer.cornerRadius = size / 2
        frontView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        frontView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        frontView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        frontView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        plusIconView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        plusIconView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        plusIconView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        plusIconView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !closed {
            for item in items {
                let itemPoint = item.convert(point, from: self)
                if item.bounds.contains(itemPoint) {
                    return item.hitTest(itemPoint, with: event)
                }
            }
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: - Method
    
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
        
        frontView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTappe))
        )
        
        overlayView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(close))
        )
    }
    
    @objc private func didTappe() {
        delegate?.didTappe()
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
                        self.plusIconView.transform = CGAffineTransform(rotationAngle: (-45 / 180.0 * CGFloat.pi))
                        self.overlayView.alpha = 1
        }, completion: {(f) -> Void in
            self.overlayViewDidCompleteOpenAnimation = true
            animationGrooup.leave()
        })
        
        popAnimationOpen(group: animationGrooup)
        
        animationGrooup.notify(queue: .main) {
            self.delegate?.didOpen()
        }
        
        closed = false
    }
    
    @objc public func close() {
        let animationGrooup = DispatchGroup()
        
        animationGrooup.enter()
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.8,
                       options: UIView.AnimationOptions(), animations: { () -> Void in
                        self.plusIconView.transform = CGAffineTransform(rotationAngle: (0 / 180.0 * CGFloat.pi))
                        self.overlayView.alpha = 0
        }, completion: {(f) -> Void in
            if self.overlayViewDidCompleteOpenAnimation {
                self.overlayView.removeFromSuperview()
            }
            animationGrooup.leave()
        })
        
        popAnimationClose(group: animationGrooup)
        
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
    
    public func addImte(item: SimpleFloatingActionButtonItem) {
        item.center.x = self.size / 2
        item.center.y = self.size / 2
        item.alpha = 0
        item.parent = self
        items.append(item)
        addSubview(item)
        sendSubviewToBack(item)
    }
    
    private func popAnimationOpen(group: DispatchGroup) {
        var itemHight: CGFloat = 0
        var delay = 0.0
        for item in items {
            itemHight += item.size + 20
            item.frame.origin.y = -itemHight
            item.isUserInteractionEnabled = true
            group.enter()
            UIView.animate(withDuration: 0.3, delay: delay,
                           usingSpringWithDamping: 0.55,
                           initialSpringVelocity: 0.3,
                           options: UIView.AnimationOptions(), animations: { () -> Void in
                            item.alpha = 1
            }, completion: { _ in
                group.leave()
            })
            delay += 0.1
        }
    }
    
    private func popAnimationClose(group: DispatchGroup) {
        var delay = 0.0
        for item in items.reversed() {
            item.isUserInteractionEnabled = false
            group.enter()
            UIView.animate(withDuration: 0.15, delay: delay, options: [], animations: { () -> Void in
                item.center.x = self.size / 2
                item.center.y = self.size / 2
                item.alpha = 0
            }, completion: { _ in
                group.leave()
            })
            delay += 0.1
        }
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
