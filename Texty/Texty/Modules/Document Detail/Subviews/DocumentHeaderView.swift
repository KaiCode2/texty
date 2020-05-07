//
//  DocumentHeaderView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-04-14.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import AVFoundation
import Combine
import TextyKit

struct DocumentHeaderView: View {
    var image: UIImage?

    @State private(set) var showCamera: Bool = false

//    @Published var showingPublisher: Bool = Published(initialValue: false)

    init(image: UIImage? = nil) {
        self.image = image
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: -50) {
            ZStack {
                imageElseBackground()
                .frame(height: 200)
                .scaleEffect(showCamera ? 3 : 1)

//                if showCamera {
//                    CameraViewLayer()
//                        .frame(height: 200)
//                        .scaleEffect(showCamera ? 3 : 1)
//                        .opacity(showCamera ? 1 : 0)
//                }

            }
            ZStack {
                Button(action: {
                    self.showCamera = false
                }) {
                    return Image(systemName: "camera.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: .center)
                        .opacity(showCamera ? 1 : 0)
                        .offset(x: 0, y: showCamera ? -35 : 0)
                        .padding(.trailing, 10)
                }
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.showCamera.toggle()
                    }
                }) {
                    return Image(systemName: showCamera ? "xmark.circle.fill" : "camera.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(.trailing, 10)
                        .offset(x: 0, y: showCamera ? 35 : 0)
                }
            }
        }
    }

    private func imageElseBackground() -> AnyView {
        if let image = image {
            return AnyView(Image(uiImage: image).resizable().scaledToFit())
        } else {
            return AnyView(Color(red: 0, green: 0.2, blue: 0.5).frame(height: 200))
        }
    }
}

fileprivate final class CameraViewLayer: UIViewRepresentable {

    typealias UIViewType = UIView

    class UICameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {

        private let captureSession = AVCaptureSession()
        private var previewLayer: CALayer!

        private var captureDevice: AVCaptureDevice!

        init() {
            super.init(frame: .zero)
            prepareCamera()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func start() {
            beginSession()
        }

        func stop() {
            captureSession.stopRunning()
            previewLayer.removeFromSuperlayer()
        }

        private func prepareCamera() {
            captureSession.sessionPreset = AVCaptureSession.Preset.photo

            if let cameraDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
                captureDevice = cameraDevice
                beginSession()
            }
        }

        private func beginSession () {
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(captureDeviceInput) {
                    captureSession.addInput(captureDeviceInput)
                }
            } catch {
                print(error.localizedDescription)
            }

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer = previewLayer
            layer.addSublayer(self.previewLayer)
            self.previewLayer.frame = layer.frame


            captureSession.startRunning()

            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String):NSNumber(value:kCVPixelFormatType_32BGRA)]

            dataOutput.alwaysDiscardsLateVideoFrames = true

            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)


                captureSession.commitConfiguration()
            }
        }

        fileprivate func captureOutput(_ captureOutput: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        }
    }

    #if os(iOS) && !targetEnvironment(simulator)
    let cameraView = UICameraView()
    #else
    private let cameraView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
    #endif

    /// Creates a `UIView` instance to be presented.
    func makeUIView(context: Context) -> UIViewType {
        #if os(iOS) && !targetEnvironment(simulator)
        cameraView.start()
        #else
        cameraView.backgroundColor = .red
        #endif
        return cameraView
    }

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    #if os(iOS) && !targetEnvironment(simulator)
    static func dismantleUIView(_ uiView: UIViewType, coordinator: Coordinator) {
        if let view = uiView as? UICameraView {
            view.stop()
        }
    }
    #endif
}

#if DEBUG
struct DocumentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentHeaderView()
    }
}
#endif
