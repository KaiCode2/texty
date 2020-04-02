//
//  CameraDocumentInteractor.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-03.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Vision
import VisionKit

protocol CameraDocumentInteractorDelegate {
    func didFinish(withDocument document: Document)
}

internal final class CameraDocumentInteractor: NSObject, VNDocumentCameraViewControllerDelegate {
    var delegate: CameraDocumentInteractorDelegate?
    private var document: Document

    init(delegate: CameraDocumentInteractorDelegate?, document: Document? = nil) {
        self.delegate = delegate
        self.document = document ?? Document(pages: [], metaData: Document.MetaData.empty())
    }

    private var textRecognitionRequest: VNRecognizeTextRequest {
        let req = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    for result in requestResults {
                        guard let candidate = result.topCandidates(1).first else { continue }
                        let line = candidate.string
                        if candidate.string.last == "-" {
                            self.document.add(pageString: line)
                        } else {
                            self.document.add(pageString: line + " ")
                        }
                    }
                    self.delegate?.didFinish(withDocument: self.document)
                }
            }
        })

        req.recognitionLevel = .accurate
        req.usesLanguageCorrection = true
        return req
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) {
                        DispatchQueue.global(qos: .userInitiated).async {
                            for pageNumber in 0 ..< scan.pageCount {
                                let image = scan.imageOfPage(at: pageNumber)
                                self.processImage(image: image)
                            }
                        }
                    }
    }
}

private extension CameraDocumentInteractor {
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
}
