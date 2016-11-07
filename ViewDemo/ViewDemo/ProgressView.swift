//
//  ProgressView.swift
//  ViewDemo
//
//  Created by mac on 7/30/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setFillColor(UIColor.green.cgColor)

        // Draw a line
        context?.beginPath()
        context?.move(to: CGPoint(x: 0, y: 0))
        context?.addLine(to: CGPoint(x: rect.size.width * progress, y: 0))
        context?.strokePath()

        // Draw a pie
        context?.beginPath()
        context?.move(to: CGPoint(x: 50, y: 50))
        // Swift 2.3
        //CGContextAddArc(context, 50, 50, 40, 0, (1.00001 - progress) * 2.0 * CGFloat(M_PI), 1)
        
        // Swift 3.0
        context?.addArc(center: CGPoint(x: 50, y: 50), radius: 40, startAngle: 0, endAngle: (1.00001 - progress) * 2.0 * CGFloat(M_PI), clockwise: true)
        context?.fillPath()

    }
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
}
