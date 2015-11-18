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
    let motionController = MotionController()
    let slopeAngleFormatter = SlopeAngleFormatter()
    let avSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var videoLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCaptureDevice()
        motionController.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        authorizeCamera {
            () -> Void in
            self.configureVideoLayer()
            self.startVideoCapture()
        }
        motionController.monitorForMotion()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        motionController.stopMonitoringMotion()
        stopVideoCapture()
    }

    //  MARK: - configure
    private func configureVideoLayer() {
        avSession.sessionPreset = AVCaptureSessionPresetHigh
        videoLayer = AVCaptureVideoPreviewLayer(session: avSession)
        if let videoLayer = videoLayer {
            videoContainer.layer.addSublayer(videoLayer)
            videoLayer.frame = self.view.layer.frame
        } else {
            showError(.CouldNotCreateCaptureVideoLayer)
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

    func authorizeCamera(completionHandler: () -> Void) {

        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {
            (granted: Bool) -> Void in
            if !granted {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showError(.NoPermissionToUseCamera)
                })
            }
            else {
                completionHandler()
            }
        });
    }

    func startVideoCapture() {
        do {
            guard let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo),
            let input: AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: captureDevice)
            else {
                showError(.NoCaptureDeviceFound)
                return
            }

            avSession.addInput(input)
            avSession.startRunning()
        } catch let error as NSError {
            showError(error)
        }
    }

    func stopVideoCapture() {
        avSession.stopRunning()
    }

//  MARK: - motion controller delegate methods

    func motionControllerDidRecieveError(motionController: MotionController, error: NSError) {
        print(error)
    }

    func motionControllerDidRecieveNewAngle(motionController: MotionController, angle: Double) {
        self.degreeLabel.text = slopeAngleFormatter.formatAngle(angle)
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

