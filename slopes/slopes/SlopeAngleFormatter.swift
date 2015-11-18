//
//  AngleFormatter.swift
//  slopes
//
//  Created by Garrett Richards on 11/17/15.
//  Copyright © 2015 Acme. All rights reserved.
//

import Foundation

public class SlopeAngleFormatter {
    private let numberFormatter: NSNumberFormatter = NSNumberFormatter()

    var decimalPlaces: Int {
        didSet {
            numberFormatter.maximumFractionDigits = decimalPlaces
        }
    }
    var showAnglesGreaterThan90: Bool = false


    public init() {
        decimalPlaces = 0
    }

    public func formatAngle(angle: Double) -> String {

        var mutableAngle = angle
        if (!showAnglesGreaterThan90) {
            //  adjust angle depending on the side device is turned torward left or right
            if (mutableAngle > 90) {
                mutableAngle = 90 - (mutableAngle - 90)
            }
        }
        //  set angle to 0 if its below zero or a -180+
        if (mutableAngle < 0) {
            mutableAngle = 0
        }

        let formattedValue = numberFormatter.stringFromNumber(NSNumber(double: mutableAngle))

        if let value = formattedValue {
            return "\(value)°"
        } else {
            return ""
        }

    }
}