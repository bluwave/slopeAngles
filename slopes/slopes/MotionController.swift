//
//  AccelerometerController.swift
//  slopes
//
//  Created by Garrett Richards on 11/17/15.
//  Copyright © 2015 Acme. All rights reserved.
//

import Foundation
import CoreMotion

public protocol MotionControllerDelegate {
    func motionControllerDidRecieveError(motionController: MotionController, error: NSError)
    func motionControllerDidRecieveNewAngle(motionController: MotionController, angle:Double)
}

public class MotionController {

    private let motionManager = CMMotionManager()
    public var delegate: MotionControllerDelegate?

    public func monitorForMotion() {
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.70
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) {
                [weak self] (data: CMAccelerometerData?, error: NSError?) in
                if let error = error {
                    self?.signalError(error)
                } else {
                    if let weakself = self {
                        var angle = -weakself.angleFromAccelerometerData(data!)
                        angle = angle.radiansToDegrees()
                        weakself.delegate?.motionControllerDidRecieveNewAngle(weakself,angle: angle)
                    }
                }
            }
        } else {
            print("no accelerometer available")
        }
    }

    public func stopMonitoringMotion() {
        motionManager.stopAccelerometerUpdates()
    }

    public func accelerometerAvailable() -> Bool {
        return motionManager.accelerometerAvailable
    }

    //  MARK: - Helpers

    public func signalError(error: NSError) {
        if let delegate = delegate {
            delegate.motionControllerDidRecieveError(self, error: error)
        } else {
            print(error)
        }
    }

    public func angleFromAccelerometerData(data: CMAccelerometerData) -> Double {
        let x = data.acceleration.x
        let y = data.acceleration.y
        var angle = M_PI / 2.0 - atan2(x, y)

        if (angle > M_PI) {
            angle -= 2 * M_PI
        }

        return angle
    }
}