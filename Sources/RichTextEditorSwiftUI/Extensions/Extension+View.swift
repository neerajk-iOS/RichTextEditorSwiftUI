//
//  Extension+View.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//

import SwiftUI

    // MARK: - Helper Extensions
extension View {
        /// Converts a SwiftUI view into a `UIView` suitable for use as an input accessory view.
        ///
        /// - Returns: A `UIView` representation of the SwiftUI view.
    func toToolbar(of height: CGFloat = 44) -> UIView {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        hostingController.view.backgroundColor = UIColor.systemGray6
        return hostingController.view
    }
}
