//
//  Extension+UiIMage.swift
//  RichText
//
//  Created by Neeraj Kumar on 19/12/24.
//
import UIKit

extension UIImage {
    /// Resizes the image to a specified size.
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
