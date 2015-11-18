//
//  SlopeView.swift
//  slopes
//
//  Created by Garrett Richards on 11/18/15.
//  Copyright © 2015 Acme. All rights reserved.
//

import UIKit

public enum Side {
    case Right
    case Left
}

public class SlopeView: UIView {

    private var shapePath: UIBezierPath?
    public var side: Side = .Right {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    }


    private func trianglePathForSide(side: Side) -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.frame
        switch (side) {
        case .Right:
            path.moveToPoint(CGPointMake(0, 0))
            path.addLineToPoint(CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)))
            path.addLineToPoint(CGPointMake(CGRectGetMaxX(rect), 0))
            break
        case .Left:
            path.moveToPoint(CGPointMake(CGRectGetMaxX(rect), 0))
            path.addLineToPoint(CGPointMake(0, CGRectGetMaxY(rect)))
            path.addLineToPoint(CGPointMake(0, 0))
            break
        }
        
        path.closePath()
        return path
    }

    override public func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext();
        let path = trianglePathForSide(self.side)
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, path.CGPath);
        self.backgroundColor?.setFill()
        CGContextDrawPath(ctx, CGPathDrawingMode.Fill);
    }

}
