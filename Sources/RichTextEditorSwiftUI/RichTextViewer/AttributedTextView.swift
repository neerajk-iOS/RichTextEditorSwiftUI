//
//  AttributedTextView.swift
//  RichText
//
//  Created by Neeraj Kumar on 16/12/24.
//
import SwiftUI

struct AttributedTextView: UIViewRepresentable {
    let attributedString: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }
}
