//
//  Extensions.swift
//  slopes
//
//  Created by Garrett Richards on 11/17/15.
//  Copyright © 2015 Acme. All rights reserved.
//

import Foundation


extension Double {

    func radiansToDegrees() ->Double {
        return self * 180/M_PI
    }
    
    func degreesToRadians() ->Double {
        return self * M_PI / 180
    }
}