//
//  MenuImageCropper.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/14/26.
//

import UIKit

struct MenuImageCropper {

    /// Crops a captured camera image using the normalized scan frame
    /// from ScanMenuView.
    ///
    /// - Parameters:
    ///   - image: The full-resolution image captured by the camera.
    ///   - normalizedFrame: A CGRect where x, y, width, and height
    ///     are values between 0 and 1.
    ///
    /// - Returns: The cropped UIImage, or the original image if
    ///   cropping fails.
    static func crop(
        image: UIImage,
        to normalizedFrame: CGRect
    ) -> UIImage {

        // Fix the image orientation before cropping.
        let normalizedImage = image.normalizedOrientation()

        guard let cgImage = normalizedImage.cgImage else {
            return image
        }

        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)

        // Convert the normalized scan frame into actual image pixels.
        var cropRect = CGRect(
            x: normalizedFrame.minX * imageWidth,
            y: normalizedFrame.minY * imageHeight,
            width: normalizedFrame.width * imageWidth,
            height: normalizedFrame.height * imageHeight
        )

        // Make sure the crop stays inside the image.
        let imageBounds = CGRect(
            x: 0,
            y: 0,
            width: imageWidth,
            height: imageHeight
        )

        cropRect = cropRect.intersection(imageBounds)

        guard
            !cropRect.isNull,
            !cropRect.isEmpty,
            let croppedCGImage = cgImage.cropping(
                to: cropRect.integral
            )
        else {
            return normalizedImage
        }

        return UIImage(
            cgImage: croppedCGImage,
            scale: normalizedImage.scale,
            orientation: .up
        )
    }
}


// MARK: - Fix Image Orientation

private extension UIImage {

    func normalizedOrientation() -> UIImage {

        // The image is already correctly oriented.
        if imageOrientation == .up {
            return self
        }

        let renderer = UIGraphicsImageRenderer(
            size: size
        )

        return renderer.image { _ in
            draw(
                in: CGRect(
                    origin: .zero,
                    size: size
                )
            )
        }
    }
}
