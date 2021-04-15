//
//  SimpleFloatingActionButton.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/14.
//

import UIKit

class SimpleFloatingActionButton: UIView {
    private let shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(hex: "ED6317", alpha: 1.0)
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private let plusIconView: PlusIconView = {
        let view = PlusIconView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

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
        shadowView.layer.cornerRadius = frame.size.width / 2
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        plusIconView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        plusIconView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        plusIconView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        plusIconView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    public func initialize() {
        addSubview(shadowView)
        addSubview(plusIconView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        plusIconView.translatesAutoresizingMaskIntoConstraints = false
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
