/// RichTextView.swift
///
/// A SwiftUI view designed for rendering and editing rich text content with full customization.
/// This view integrates a rich text editor, toolbar, and external pickers for media and formatting options.
///
/// - Author: Neeraj Kumar
/// - Created: 13/12/24
///

import SwiftUI

/// A customizable SwiftUI view for rich text editing.
///
/// `RichTextView` combines a rich text editor with a configurable toolbar,
/// offering features like image and file insertion, text color customization,
/// and font selection.
public struct RichTextView: View {
    
    // MARK: - Properties
    
    /// The view model managing the rich text editor state.
    @EnvironmentObject private var viewModel: RichTextEditorViewModel
    
    /// Toolbar configuration passed externally for customization.
    let toolbarConfig: RichTextToolbarConfig
    
    /// Vertical alignment for layout.
    let verticalAlignment: VerticalAlignment
    
    /// Initializes the `RichTextView`.
    ///
    /// - Parameters:
    ///   - toolbarConfig: Configuration for toolbar buttons.
    ///   - verticalAlignment: Vertical alignment for the text editor.
    public init(
        toolbarConfig: RichTextToolbarConfig = RichTextToolbarConfig(),
        verticalAlignment: VerticalAlignment = .center
    ) {
        self.toolbarConfig = toolbarConfig
        self.verticalAlignment = verticalAlignment
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack {
            // Render the rich text editor
            RichTextField(text: $viewModel.text, config: toolbarConfig)
                .environmentObject(viewModel)
                .padding()
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .modifier(PickerSheetsModifier(viewModel: viewModel))
    }
}

