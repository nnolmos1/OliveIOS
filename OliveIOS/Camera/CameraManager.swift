//
//  CameraManager.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/14/26.
//

import SwiftUI
import Combine
import AVFoundation

final class CameraManager: NSObject, ObservableObject {

    // MARK: - Published Properties

    @Published var permissionGranted = false
    @Published var capturedImage: UIImage?
    @Published var isSessionRunning = false

    // MARK: - Camera Properties

    let session = AVCaptureSession()

    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    // MARK: - Initialization

    override init() {
        super.init()
        checkPermission()
    }

    // MARK: - Permissions

    private func checkPermission() {

        switch AVCaptureDevice.authorizationStatus(for: .video) {

        case .authorized:
            permissionGranted = true
            configureSession()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.permissionGranted = granted

                    if granted {
                        self.configureSession()
                    }
                }
            }

        default:
            permissionGranted = false
        }
    }

    // MARK: - Session Configuration

    private func configureSession() {

        sessionQueue.async {

            self.session.beginConfiguration()

            self.session.sessionPreset = .photo

            guard
                let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                     for: .video,
                                                     position: .back),
                let input = try? AVCaptureDeviceInput(device: camera)
            else {
                return
            }

            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }

            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
            }

            self.photoOutput.isHighResolutionCaptureEnabled = true

            self.session.commitConfiguration()

            self.startSession()
        }
    }

    // MARK: - Session Controls

    func startSession() {

        sessionQueue.async {

            guard !self.session.isRunning else { return }

            self.session.startRunning()

            DispatchQueue.main.async {
                self.isSessionRunning = true
            }
        }
    }

    func stopSession() {

        sessionQueue.async {

            guard self.session.isRunning else { return }

            self.session.stopRunning()

            DispatchQueue.main.async {
                self.isSessionRunning = false
            }
        }
    }

    // MARK: - Capture Photo

    func capturePhoto() {

        let settings = AVCapturePhotoSettings()

        settings.flashMode = .off

        if photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
            settings.isHighResolutionPhotoEnabled = true
        }

        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraManager: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {

        guard
            error == nil,
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else {
            return
        }

        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}

