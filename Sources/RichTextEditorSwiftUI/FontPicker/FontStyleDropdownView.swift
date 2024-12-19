//
//  FontStyleDropdownView.swift
//  RichText
//
//  Created by Neeraj Kumar on 18/12/24.
//

import SwiftUI

/// A dropdown component for selecting font styles like Title, Subheading, and Body.
struct FontStyleDropdown: View {
    @ObservedObject var viewModel: RichTextEditorViewModel

    let styles: [String] = ["Large Title", "Title", "Title2", "Title3", "Heading", "Subheading", "Body", "Footnote", "Caption", "Caption2"]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Font Style")
                .font(.caption)
                .padding(.bottom, 4)

            Menu {
                ForEach(styles, id: \.self) { style in
                    Button(action: {
                        viewModel.setFontStyle(style)
                    }) {
                        HStack {
                            Text(style)
                                .font(Font(viewModel.styleFont(for: style, baseFont: viewModel.selectedFont ?? UIFont.systemFont(ofSize: viewModel.fontSize))))
                            if viewModel.selectedFontStyle == style {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedFontStyle ?? "Body")
                        .font(.body)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
        }
    }
}
