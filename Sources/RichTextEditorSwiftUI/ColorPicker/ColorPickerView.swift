//
//  ColorPickerView.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//

import SwiftUI

/// A dropdown view for selecting colors.
struct ColorPickerDropdownView: View {
    @ObservedObject var viewModel: RichTextEditorViewModel
    let isBackground: Bool
    var onDone: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Text(isBackground ? "Background Color" : "Text Color")
                    .font(.caption)
                    .padding(.bottom, 8)

                ColorPicker("", selection: Binding(
                    get: { Color(isBackground ? viewModel.textBackgroundColor : viewModel.textForegroundColor) },
                    set: { newColor in
                        if isBackground {
                            viewModel.textBackgroundColor = UIColor(newColor)
                        } else {
                            viewModel.textForegroundColor = UIColor(newColor)
                        }
                    }
                ))
                .labelsHidden()

                Button("Done") {
                    onDone()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .transition(.opacity)

        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
        .ignoresSafeArea()
    }
}
