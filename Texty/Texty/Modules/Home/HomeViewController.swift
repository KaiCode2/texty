//
//  ViewController.swift
//  Texty
//
//  Created by Kai Aldag on 2019-06-07.
//  Copyright © 2019 Kai Aldag. All rights reserved.
//

import UIKit
import Vision
import VisionKit
import AVFoundation

class HomeViewController: UIViewController {
    private let presenter: HomePresenter

    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var textRecognitionRequest = VNRecognizeTextRequest()
    var pageString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    for result in requestResults {
                        guard let candidate = result.topCandidates(1).first else { continue }
                        self.pageString += " " + candidate.string
                    }
                    let utterance = AVSpeechUtterance(string: self.pageString)
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.6

                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }
            }
        })

        // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
//        delegate.didRequestScan()
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }

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

extension HomeViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//            self.activityIndicator.startAnimating()

            controller.dismiss(animated: true) {
                DispatchQueue.global(qos: .userInitiated).async {
                    for pageNumber in 0 ..< scan.pageCount {
                        let image = scan.imageOfPage(at: pageNumber)
                        self.processImage(image: image)
                    }
                    DispatchQueue.main.async {
    //                    if let resultsVC = self.resultsViewController {
    //                        self.navigationController?.pushViewController(resultsVC, animated: true)
    //                    }
//                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
}

