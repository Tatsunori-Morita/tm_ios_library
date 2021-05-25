//
//  SimpleFloatingActionButtonItem.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/05/24.
//

import UIKit

class SimpleFloatingActionButtonItem: UIView {
    
    public var size: CGFloat = 44
    
    public var tapped: ((SimpleFloatingActionButtonItem) -> Void)?
    
    public var parent: SimpleFloatingActionButton?

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .red
        layer.cornerRadius = size / 2
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        parent?.close()
        tapped?(self)
    }
}
