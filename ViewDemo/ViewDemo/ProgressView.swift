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
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetFillColorWithColor(context, UIColor.greenColor().CGColor)

        // Draw a line
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, rect.size.width * progress, 0)
        CGContextStrokePath(context)

        // Draw a pie
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 50, 50)
        CGContextAddArc(context, 50, 50, 40, 0, (1.00001 - progress) * 2.0 * CGFloat(M_PI), 1)
        CGContextFillPath(context)

    }
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
}
