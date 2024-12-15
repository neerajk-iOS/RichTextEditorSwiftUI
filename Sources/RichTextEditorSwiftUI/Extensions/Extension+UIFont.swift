//
//  Extension+UIFont.swift
//  RichText
//
//  Created by Neeraj Kumar on 15/12/24.
//

import UIKit
import SwiftUI

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let systemFontDescriptor = UIFontDescriptor(name: self.fontName, size: self.pointSize)
        let newDescriptor = systemFontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: weight.rawValue]
        ])
        return UIFont(descriptor: newDescriptor, size: self.pointSize)
    }
}

extension Font.Weight {
    static func fromUIFontWeight(_ uiFontWeight: UIFont.Weight) -> Font.Weight {
        switch uiFontWeight {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
    }
}
