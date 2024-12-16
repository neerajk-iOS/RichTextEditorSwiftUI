//
//  RichTextViewer.swift
//  RichText
//
//  Created by Neeraj Kumar on 16/12/24.
//
import UIKit
import SwiftUI

/// A wrapper to display NSAttributedString using UILabel in SwiftUI.
struct RichTextViewWrapper: UIViewRepresentable {
    let attributedString: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
               textView.isEditable = false
               textView.backgroundColor = .clear
               textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) // Padding inside
               textView.textContainer.lineFragmentPadding = 0 // Ensure proper text alignment to edges
               textView.textContainer.lineBreakMode = .byWordWrapping
               textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }
}


