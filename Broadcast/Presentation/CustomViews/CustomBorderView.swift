//
//  CustomBorderView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/12/20.
//

import UIKit

class CustomBorderView: UIView {
    
    private let dashedLineColor = UIColor.dashedBorder
    private let dashedLinePattern: [NSNumber] = [6, 3]
    private let dashedLineWidth: CGFloat = 1

    private let borderLayer = CAShapeLayer()

    init() {
        super.init(frame: CGRect.zero)

        borderLayer.strokeColor = dashedLineColor.cgColor
        borderLayer.lineDashPattern = dashedLinePattern
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = dashedLineWidth
        layer.addSublayer(borderLayer)
        clipsToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).cgPath
    }

}
