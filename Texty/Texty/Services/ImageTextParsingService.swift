//
//  ImageTextParsingService.swift
//  Texty
//
//  Created by Kai Aldag on 2020-12-30.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Vision
import VisionKit

internal struct ImageTextParsingService {
    
    /// Parses a visionDocument object and returns a Texty compliant Document object. Work is done asynchronously
    func parse(visionDocument: VNDocumentCameraScan) {
        DispatchQueue.global(qos: .userInitiated).async {
            for pageNumber in 0 ..< visionDocument.pageCount {
                let image = visionDocument.imageOfPage(at: pageNumber)
                self.processImage(image: image)
            }
            /// TODO: use publisher to publish results of the parsing
//            self.delegate?.didFinish(withDocument: self.document)
        }
    }
}

private extension ImageTextParsingService {
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([makeTextRecognitionRequest()])
        } catch {
            print(error)
        }
    }

    func makeTextRecognitionRequest() -> VNRecognizeTextRequest {
        /// TODO: Use NSTextCheckingTypes to gain insight into the text scan. Specifically, extend NSTextCheckingTypes to include custom types for page numbers, author, publication date, etc. Additionally, check UIDataDetectorTypes.lookupSuggestion to suggest internet searches to user. (Link https://developer.apple.com/documentation/uikit/uidatadetectortypes/1648141-lookupsuggestion)
        let req = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    let newPageString = requestResults.reduce("") { (textString, result) -> String in
                        guard let candidate = result.topCandidates(1).first else {
                            print("WARNING: could not load candidate for line")
                            return ""
                        }
                        let line = candidate.string
                        if candidate.string.last == "-" {
                            return textString + line
                        } else {
                            return textString + " " + line
                        }
                    }
                    // Check if last line contains numbers. If so, add new string - minus the last line of text - and page number. Else, add just new string
                    if let lastLine = requestResults.last?.topCandidates(1).first,
                       let pageNumberString = lastLine.string.components(separatedBy: CharacterSet.decimalDigits.inverted).filter({ $0.count != 0 }).first,
                       let pageNumber = Int(pageNumberString) {
                        var updatedString = newPageString
                        updatedString.removeLast(lastLine.string.count)
//                        self.document.add(pageString: updatedString, number: pageNumber, image: nil)
                    } else {
//                        self.document.add(pageString: newPageString)
                    }
                }
            }
        })

        req.recognitionLevel = .accurate
        req.usesLanguageCorrection = true
        return req
    }
}
