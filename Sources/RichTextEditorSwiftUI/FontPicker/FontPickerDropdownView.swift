//
//  FontPickerView.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//

import SwiftUI
/// A dropdown view for selecting font family and font weight.
///
/// `FontPickerDropdownView` allows users to select both font family and weight
/// inline within a toolbar dropdown context, offering a compact and intuitive design.
struct FontPickerDropdownView: View {
    @ObservedObject var viewModel: RichTextEditorViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            // Font Family Picker
            FontFamilyDropdown(viewModel: viewModel)
            
            // Font Weight Picker
            FontWeightDropdown(viewModel: viewModel)
            
            // Done Button
            Button(action: {
                viewModel.applyFormatting()
                viewModel.showFontPickerMenu = false // Close dropdown
            }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(maxWidth: 250)
    }
}
