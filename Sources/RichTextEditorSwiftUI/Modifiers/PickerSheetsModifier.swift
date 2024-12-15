//
//  PickerSheetsModifier.swift
//  RichText
//
//  Created by Neeraj Kumar on 16/12/24.
//

import SwiftUI

/// A SwiftUI view modifier for managing picker sheets.
///
/// This modifier simplifies the integration of external pickers like image, file, and color pickers.
struct PickerSheetsModifier: ViewModifier {
    @ObservedObject var viewModel: RichTextEditorViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $viewModel.isPhotoLibraryPickerPresented) {
                PhotoLibraryPicker { image in
                    viewModel.insertImage(image)
                }
            }
            .sheet(isPresented: $viewModel.isCameraPickerPresented) {
                CameraImagePicker(onImagePicked: { image in
                    viewModel.insertImage(image)
                }, sourceType: .camera)
            }
            .sheet(isPresented: $viewModel.isFilePickerPresented) {
                FilePicker(isPresented: $viewModel.isFilePickerPresented) { fileURL in
                    viewModel.insertFile(fileURL)
                }
            }
            .sheet(isPresented: $viewModel.showingTextColorPicker) {
                ColorPickerDropdownView(viewModel: viewModel, isBackground: false) {
                    viewModel.showingTextColorPicker = false
                    viewModel.applyFormatting()
                }
            }
            .sheet(isPresented: $viewModel.showingBackgroundColorPicker) {
                ColorPickerDropdownView(viewModel: viewModel, isBackground: true) {
                    viewModel.showingBackgroundColorPicker = false
                    viewModel.applyFormatting()

                }
            }
            .sheet(isPresented: $viewModel.showFontPickerMenu) {
                FontPickerDropdownView(viewModel: viewModel)
            }
    }
}

