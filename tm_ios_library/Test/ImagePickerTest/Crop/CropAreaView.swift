//
//  CropAreaView.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/03/01.
//

import UIKit

class CropAreaView: UIView {
    private let borderWidth: CGFloat = 1
    private var halfBorderWidth: CGFloat { return borderWidth / 2 }
    private var doubleBorderWidth: CGFloat { return borderWidth * 2 }

    private var borderLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCropArea()
    }

    private func initialize() {
        backgroundColor = .black
        alpha = 0.5
        isUserInteractionEnabled = false
    }

    private func setupCropArea() {
        setupCropAreaMask()
        setupBorder()
    }

    private func setupCropAreaMask() {
        let cropAreaPath = UIBezierPath(rect: CGRect(
            x: borderWidth,
            y: cropAreaPositionY + borderWidth,
            width: cropAreaWidth - doubleBorderWidth,
            height: cropAreaHeight - doubleBorderWidth))

        let outsideCropAreaPath = UIBezierPath(rect: CGRect(
            x: 0, y: 0,
            width: bounds.width,
            height: bounds.height))

        cropAreaPath.append(outsideCropAreaPath)

        let cropAreaLayer = CAShapeLayer()
        cropAreaLayer.path = cropAreaPath.cgPath
        cropAreaLayer.fillColor = UIColor.black.cgColor
        cropAreaLayer.fillRule = .evenOdd
        layer.mask = cropAreaLayer
    }

    private func setupBorder() {
        borderLayer?.removeFromSuperlayer()

        let border = CAShapeLayer()
        let borderPath = UIBezierPath(rect: CGRect(
            x: halfBorderWidth,
            y: cropAreaPositionY + halfBorderWidth,
            width: cropAreaWidth - borderWidth,
            height: cropAreaHeight - borderWidth))
        border.path = borderPath.cgPath
        border.lineWidth = borderWidth
        border.strokeColor = UIColor.white.cgColor
        layer.addSublayer(border)

        borderLayer = border
    }

    private var cropAreaWidth: CGFloat {
        return bounds.width
    }

    private var cropAreaHeight: CGFloat {
        return cropAreaWidth //* 10 / 10
    }

    private var cropAreaPositionY: CGFloat {
        return (bounds.height - cropAreaHeight) / 2
    }
}

extension CropAreaView {
    var cropAreaRect: CGRect {
        return CGRect(
            x: 0,
            y: cropAreaPositionY,
            width: cropAreaWidth,
            height: cropAreaHeight)
    }
}
