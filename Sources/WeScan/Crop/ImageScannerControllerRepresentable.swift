//
//  ImageScannerControllerRepresentable.swift
//  WeScan
//
//  Created by Furkan Simsir on 30/07/2025.
//

import SwiftUI
import UIKit

struct ImageScannerControllerRepresentable: UIViewControllerRepresentable {
  var image: UIImage
  var onImageScanned: (UIImage) -> Void
  var onCancel: () -> Void

  func makeUIViewController(context: Context) -> WeScan.ImageScannerController {
    WeScan.ImageScannerController(image: image, delegate: context.coordinator)
  }

  func updateUIViewController(_ uiViewController: WeScan.ImageScannerController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, ImageScannerControllerDelegate {
    var parent: ImageScannerControllerRepresentable

    init(_ parent: ImageScannerControllerRepresentable) {
      self.parent = parent
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
      print("Error occurred during scanning: \(error)")
      parent.onCancel()
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
      parent.onImageScanned(results.userSelectedScan.image)
      scanner.dismiss(animated: true)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
      parent.onCancel()
      scanner.dismiss(animated: true)
    }
  }
}

private extension ImageScannerResults {
  var userSelectedScan: ImageScannerScan {
    (doesUserPreferEnhancedScan ? enhancedScan ?? croppedScan : croppedScan)
  }
}
