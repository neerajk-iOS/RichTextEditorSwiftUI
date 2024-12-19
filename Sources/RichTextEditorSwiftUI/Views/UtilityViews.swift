//
//  UtilityViews.swift
//  RichText
//
//  Created by Neeraj Kumar on 18/12/24.
//
import SwiftUI

// MARK: - Transparent Background View
struct TransparentBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear // Make background clear
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - Blur Background View
struct BlurBackgroundView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = .clear // Ensures transparency of the blur
        return blurView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
