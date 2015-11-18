//
//  ViewController.swift
//  slopes
//
//  Created by Garrett Richards on 11/17/15.
//  Copyright © 2015 Acme. All rights reserved.
//

import UIKit
import AVFoundation

public enum VideoError: ErrorType {
    case CouldNotCreateCaptureVideoLayer
    case NoCaptureDeviceFound
    case NoPermissionToUseCamera
}

class ViewController: UIViewController, MotionControllerDelegate {

    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var slopeView: SlopeView!
    let motionController = MotionController()
    let slopeAngleFormatter = SlopeAngleFormatter()
    let avSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var videoLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        motionController.delegate = self
        configureSlopeView()
        configureDegreeLabel()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        authorizeCamera {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                [weak self] in
                if let weakself = self {
                    weakself.configureCaptureDevice()
                    weakself.configureVideoLayer()
                    weakself.startVideoCapture()
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        motionController.monitorForMotion()
        adjustVideoCaptureLayerBounds()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        motionController.stopMonitoringMotion()
        stopVideoCapture()
    }

    //  MARK: - configure

    private func configureDegreeLabel() {
        degreeLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0))
    }

    private func configureSlopeView() {
        slopeView.side = .Right
    }

    private func configureVideoLayer() {
        avSession.sessionPreset = AVCaptureSessionPresetHigh
        addVideoInputToSession(avSession)
        videoLayer = AVCaptureVideoPreviewLayer(session: avSession)
        if let videoLayer = videoLayer {
            videoContainer.layer.addSublayer(videoLayer)
            adjustVideoCaptureLayerBounds()
        } else {
            showError(.CouldNotCreateCaptureVideoLayer)
        }
    }

    func adjustVideoCaptureLayerBounds() {
        if let videoLayer = videoLayer {
            videoLayer.frame = self.view.layer.frame
        }
    }

    //  TODO - add error as parameter here for caller
    func addVideoInputToSession(session: AVCaptureSession) {
        do {
            guard let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo),
            let input: AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: captureDevice)
            else {
                showError(.NoCaptureDeviceFound)
                return
            }
            session.addInput(input)
        } catch let error as NSError {
            showError(error)
        }
    }

    private func configureCaptureDevice() {
        captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    break
                }
            }
        }
    }

    //  MARK: - video control
    //  TODO - move all video to it's own controller

    private func authorizeCamera(completionHandler: () -> Void) {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {
            (granted: Bool) -> Void in
            if !granted {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showError(.NoPermissionToUseCamera)
                })
            } else {
                completionHandler()
            }
        });
    }

    private func startVideoCapture() {
        avSession.startRunning()
    }

    private func stopVideoCapture() {
        avSession.stopRunning()
    }

//  MARK: - motion controller delegate methods

    func motionControllerDidRecieveError(motionController: MotionController, error: NSError) {
        print(error)
    }

    func motionControllerDidRecieveNewAngle(motionController: MotionController, angle: Double) {
        self.degreeLabel.text = slopeAngleFormatter.formatAngle(angle)

        if (angle > 0) {
            self.slopeView.side = angle > 90 ? .Right : .Left
        }
    }

//  MARK: - helpers

    private func showError(videoError: VideoError) {
        //  TODO - bubble these up to the user
        print("video error: \(videoError)")
    }

    private func showError(error: String) {
        //  TODO - bubble these up to the user
        print("error: \(error)")
    }

    private func showError(error: NSError?) {
        //  TODO - bubble these up to the user
        print("error: \(error?.localizedDescription)")
    }

}

