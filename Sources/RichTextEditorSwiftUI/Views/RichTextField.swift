/// RichTextField.swift
/// This file implements the `RichTextField` component, a bridge between UIKit's `UITextView`
/// and SwiftUI, for rendering and editing attributed strings in a SwiftUI environment.
///
/// - Author: Neeraj Kumar
/// - Created: 13/12/24

import SwiftUI

/// A SwiftUI wrapper for `UITextView`, enabling rich text editing.
///
/// `RichTextField` integrates UIKit's `UITextView` into SwiftUI, allowing the rendering
/// and editing of attributed strings with support for toolbars and state management.

public struct RichTextField: UIViewRepresentable {
    
    // MARK: - Properties
    
    /// The attributed string being edited or rendered in the text view.
    @Binding var text: NSAttributedString
    
    /// The view model managing the rich text editor's state and behaviors.
    @EnvironmentObject var viewModel: RichTextEditorViewModel
    
    /// Configuration for the toolbar attached to the text view.
    let config: RichTextToolbarConfig
    
    // MARK: - UIViewRepresentable Methods
    
    /// Creates and configures the `UITextView` instance used by this view.
    ///
    /// - Parameter context: The context containing coordinator and environment information.
    /// - Returns: A configured `UITextView` instance.
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.attributedText = text
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = .clear
        
        // Attach the toolbar as the input accessory view.
        let toolbar = RichTextToolbar(viewModel: viewModel, config: config).toToolbar(of: config.toolbarHeight)
        textView.inputAccessoryView = toolbar
        return textView
    }
    
    /// Updates the `UITextView` with new data or state changes from SwiftUI.
    ///
    /// - Parameters:
    ///   - uiView: The `UITextView` instance to update.
    ///   - context: Contextual information for the update.
    public func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.attributedText != text {
            uiView.attributedText = text
        }
    }
    
    /// Creates the coordinator instance for managing the `UITextView`'s events.
    ///
    /// - Returns: A new `Coordinator` instance.
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    /// A coordinator to handle `UITextView` delegate events.
    public class Coordinator: NSObject, UITextViewDelegate {
        
        /// The parent `RichTextField` instance.
        var parent: RichTextField
        
        /// Initializes a new `Coordinator` for the given `RichTextField`.
        ///
        /// - Parameter parent: The `RichTextField` instance associated with this coordinator.
        init(_ parent: RichTextField) {
            self.parent = parent
        }
        
        /// Notifies when the text view's selection changes.
        ///
        /// - Parameter textView: The `UITextView` whose selection has changed.
        public func textViewDidChangeSelection(_ textView: UITextView) {
            let newRange = textView.selectedRange
            if NSLocationInRange(newRange.location, NSRange(location: 0, length: textView.text.count)) {
                parent.viewModel.selectedRange = newRange
            } else {
                parent.viewModel.selectedRange = NSRange(location: 0, length: 0)
            }
        }
        
        /// Notifies when the text view's content changes.
        ///
        /// - Parameter textView: The `UITextView` whose content has changed.
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.attributedText
        }
    }
}
