//
//  HyperlinkInputView.swift
//  RichTextEditorSwiftUI
//
//  Created by Neeraj Kumar on 17/12/24.
//
import SwiftUI

struct HyperlinkInputView: View {
    @Binding var url: String
    @State private var linkText: String = "" // User input for link text
    var selectedRangeLength: Int
    var onSubmit: (String, String?) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if selectedRangeLength == 0 {
                // Show TextField for link text if no text is selected
                VStack(alignment: .leading) {
                    Text("Link Text")
                        .font(.caption)
                    TextField("Enter link text", text: $linkText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            VStack(alignment: .leading) {
                Text("Link URL")
                    .font(.caption)
                TextField("Enter URL", text: $url)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button("Add Hyperlink") {
                onSubmit(url, selectedRangeLength > 0 ? nil : linkText)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
