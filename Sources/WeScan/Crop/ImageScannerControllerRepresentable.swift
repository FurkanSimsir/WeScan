//
//  ImageScannerControllerRepresentable.swift
//  WeScan
//
//  Created by Furkan Simsir on 30/07/2025.
//

import SwiftUI
import UIKit

public struct ImageScannerControllerRepresentable: UIViewControllerRepresentable {
  var image: UIImage
  var onImageScanned: (UIImage) -> Void
  var onCancel: () -> Void

  public init(image: UIImage, onImageScanned: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
    self.image = image
    self.onImageScanned = onImageScanned
    self.onCancel = onCancel
  }

  public func makeUIViewController(context: Context) -> WeScan.ImageScannerController {
    WeScan.ImageScannerController(image: image, delegate: context.coordinator)
  }

  public func updateUIViewController(_ uiViewController: WeScan.ImageScannerController, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: NSObject, ImageScannerControllerDelegate {
    var parent: ImageScannerControllerRepresentable

    init(_ parent: ImageScannerControllerRepresentable) {
      self.parent = parent
    }

    public func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
      print("Error occurred during scanning: \(error)")
      parent.onCancel()
    }

    public func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
      parent.onImageScanned(results.userSelectedScan.image)
      scanner.dismiss(animated: true)
    }

    public func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
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
