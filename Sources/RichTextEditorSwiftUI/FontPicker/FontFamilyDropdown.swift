//
//  FontWeghtDropDown.swift
//  RichText
//
//  Created by Neeraj Kumar on 16/12/24.
//
import SwiftUI

/// A dropdown component for selecting font families.
struct FontFamilyDropdown: View {
    @ObservedObject var viewModel: RichTextEditorViewModel
    let config: RichTextToolbarConfig

    private var availableFontFamilies: [String] {
        let systemFonts = UIFont.familyNames
        let projectFonts = config.projectFonts
        return (systemFonts + projectFonts).sorted()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Font Family")
                .font(.caption)
                .padding(.bottom, 4)

            Menu {
                ForEach(viewModel.availableFonts, id: \.self) { font in
                    Button(action: {
                        viewModel.setFontFamily(font)
                    }) {
                        HStack {
                            Text(font)
                                .font(.custom(font, size: 16))
                            if viewModel.selectedFontFamily == font {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedFontFamily)
                        .font(.custom(viewModel.selectedFontFamily, size: 16))
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
