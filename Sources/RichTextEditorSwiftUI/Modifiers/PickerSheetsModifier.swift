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
/// Modifier to handle picker sheets with configurable appearance.
struct PickerSheetsModifier: ViewModifier {
    @ObservedObject var viewModel: RichTextEditorViewModel
    var config: PickerSheetConfig
    var toolbarConfig: RichTextToolbarConfig
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: config.blurEffect && isAnySheetPresented ? 10 : 0)
                .animation(.easeInOut, value: isAnySheetPresented)

            if config.blurEffect && isAnySheetPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $viewModel.isPhotoLibraryPickerPresented) {
            adaptiveSheet {
                PhotoLibraryPicker { image in
                    viewModel.insertImage(image)
                }
            }
        }
        .sheet(isPresented: $viewModel.isCameraPickerPresented) {
            adaptiveSheet {
                CameraImagePicker(onImagePicked: { image in
                    viewModel.insertImage(image)
                }, sourceType: .camera)
            }
        }
        .sheet(isPresented: $viewModel.isFilePickerPresented) {
            adaptiveSheet {
                FilePicker(isPresented: $viewModel.isFilePickerPresented) { fileURL in
                    viewModel.insertFile(fileURL)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingTextColorPicker) {
            adaptiveSheet {
                ColorPickerDropdownView(viewModel: viewModel, isBackground: false) {
                    viewModel.showingTextColorPicker = false
                    viewModel.applyFormatting()
                }
            }
        }
        .sheet(isPresented: $viewModel.showingBackgroundColorPicker) {
            adaptiveSheet {
                ColorPickerDropdownView(viewModel: viewModel, isBackground: true) {
                    viewModel.showingBackgroundColorPicker = false
                    viewModel.applyFormatting()
                }
            }
        }
        .sheet(isPresented: $viewModel.showFontPickerMenu) {
            adaptiveSheet {
                FontPickerDropdownView(viewModel: viewModel, config: toolbarConfig)
            }
        }
        .sheet(isPresented: $viewModel.isHyperlinkPromptPresented) {
            adaptiveSheet {
                HyperlinkInputView(url: $viewModel.hyperlinkURL, selectedRangeLength: viewModel.selectedRange.length) { urlString, linkText in
                            viewModel.addHyperlink(urlString: urlString, linkText: linkText)
                            viewModel.isHyperlinkPromptPresented = false
                        }
            }
           
        }
    }

    // MARK: - Helpers

    /// Tracks if any sheet is currently presented.
    private var isAnySheetPresented: Bool {
        viewModel.isPhotoLibraryPickerPresented ||
        viewModel.isCameraPickerPresented ||
        viewModel.isFilePickerPresented ||
        viewModel.showingTextColorPicker ||
        viewModel.showingBackgroundColorPicker ||
        viewModel.showFontPickerMenu
    }

    /// A reusable adaptive sheet modifier with configurable properties.
    @ViewBuilder
    private func adaptiveSheet<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack {
            content()
                .padding()
        }
        .presentationDetents(config.detents)
        .presentationDragIndicator(.hidden)
        .background(TransparentBackgroundView()) // Add transparent background view
    }
}

