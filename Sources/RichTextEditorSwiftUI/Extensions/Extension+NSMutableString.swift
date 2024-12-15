//
//  Extension+NSMutableString.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//
import Foundation

    // MARK: - Extensions
extension NSMutableAttributedString {
    func appending(attributedString: NSAttributedString) -> NSMutableAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        copy.append(attributedString)
        return copy
    }
}
