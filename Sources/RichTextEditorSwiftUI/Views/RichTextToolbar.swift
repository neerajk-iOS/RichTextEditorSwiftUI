//
//  RichTextToolbar.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//

import SwiftUI

/// A customizable toolbar for managing rich text editor actions.
///
/// The `RichTextToolbar` dynamically renders button groups, dropdowns,
/// and menus based on the provided `RichTextToolbarConfig`.
public struct RichTextToolbar: View {
    @ObservedObject var viewModel: RichTextEditorViewModel
    let config: RichTextToolbarConfig

    /// Initializes the toolbar with a view model and configuration.
    ///
    /// - Parameters:
    ///   - viewModel: The view model managing the editor state.
    ///   - config: The configuration for the toolbar's layout and buttons.
    public init(viewModel: RichTextEditorViewModel, config: RichTextToolbarConfig = RichTextToolbarConfig()) {
        self.viewModel = viewModel
        self.config = config
    }

    public var body: some View {
        VStack( alignment: .leading,spacing: 4) { // Adjust spacing for better alignment
            ForEach(config.buttonGroups.indices, id: \.self) { groupIndex in
                // Check content width to disable ScrollView if not needed
                let buttonCount = config.buttonGroups[groupIndex].count
                let totalWidth = CGFloat(buttonCount) * 36.0 + CGFloat(buttonCount - 1) * config.spacing

                if totalWidth > UIScreen.main.bounds.width - 32 { // Enable scrolling if buttons overflow
                    ScrollView(.horizontal, showsIndicators: false) {
                        toolbarButtonRow(for: groupIndex)
                    }
                    .padding(.horizontal, 4)
                } else {
                    toolbarButtonRow(for: groupIndex) // Disable scrolling
                        .padding(.horizontal, 4)
                }
            }
        }
        .frame(minHeight: config.toolbarHeight, maxHeight: config.toolbarHeight)
        .cornerRadius(8)
        .padding(.horizontal, 8)
    }
    
    // MARK: - Helper for Button Rows
    private func toolbarButtonRow(for groupIndex: Int) -> some View {
        HStack(spacing: config.spacing) {
            ForEach(config.buttonGroups[groupIndex], id: \.id) { buttonConfig in
                toolbarButton(for: buttonConfig)
            }
        }
        .frame(minHeight: 32) // Ensure minimum button height
    }

    // MARK: - Private Helper Methods

    /// Renders a button based on its type (normal, dropdown, or menu).
    private func toolbarButton(for buttonConfig: RichTextToolbarConfig.ButtonConfig) -> some View {
        switch buttonConfig.buttonType {
        case .normal:
            return AnyView(normalButton(for: buttonConfig))
        case .dropdown(let subButtons):
            return AnyView(dropdownButton(for: buttonConfig, subButtons: subButtons))
        case .menu(let menuButtons):
            return AnyView(menuButton(for: buttonConfig, menuButtons: menuButtons))
        }
    }

    /// Creates a normal button.
    private func normalButton(for buttonConfig: RichTextToolbarConfig.ButtonConfig) -> some View {
        
        let isActive: Bool
           switch buttonConfig.type {
           case .bold: isActive = viewModel.isBold
           case .italic: isActive = viewModel.isItalic
           case .underline: isActive = viewModel.isUnderline
           case .strikethrough: isActive = viewModel.isStrikethrough
           default: isActive = false
           }

           return Button(action: {
               handleAction(for: buttonConfig.type)
           }) {
               
               if let image = buttonConfig.icon {
                   Image(image)
                       .resizable()
                       .frame(width: buttonConfig.size.width, height: buttonConfig.size.height)
                       .foregroundColor(isActive ? .blue : buttonConfig.tint) // Highlight active state
               } else {
                   Image(systemName: buttonConfig.defaultIcon)
                       .resizable()
                       .frame(width: buttonConfig.size.width, height: buttonConfig.size.height)
                       .foregroundColor(isActive ? .blue : buttonConfig.tint) // Highlight active state
               }
           }
           .buttonStyle(PlainButtonStyle())
    }

    /// Creates a dropdown button for different dropdown configurations.
    private func dropdownButton(for buttonConfig: RichTextToolbarConfig.ButtonConfig, subButtons: [RichTextToolbarConfig.ButtonConfig]) -> some View {
        ZStack {
            if buttonConfig.type == .textColorPicker && viewModel.showingTextColorPicker {
                VStack {
                    ColorPickerDropdownView(viewModel: viewModel, isBackground: false) {
                        viewModel.showingTextColorPicker = false
                        viewModel.applyFormatting()
                    }
                    Spacer()
                }
                .transition(.move(edge: .bottom))
            } else if buttonConfig.type == .backgroundColorPicker && viewModel.showingBackgroundColorPicker {
                VStack {
                    ColorPickerDropdownView(viewModel: viewModel, isBackground: true) {
                        viewModel.showingBackgroundColorPicker = false
                        viewModel.applyFormatting()
                    }
                    Spacer()
                }
                .transition(.move(edge: .bottom))
            } else if buttonConfig.type == .insertImage && viewModel.showingImagePickerDropdown{
                VStack {
                    ImagePickerOptionsView(viewModel: viewModel)
                    Spacer()
                }
                .transition(.move(edge: .bottom))

            } else {
                Button(action: {
                     handleDropdownAction(for: buttonConfig.type)
                 }) {
                     HStack(spacing: 6) {
                         if let image = buttonConfig.icon {
                             Image(image)
                                 .resizable()
                                 .frame(width: buttonConfig.size.width, height: buttonConfig.size.height)
                         } else {
                             
                             HStack {
                                 // Display the current selected value dynamically
                                 if currentValue(for: buttonConfig.type) == "" {
                                     Image(systemName: buttonConfig.defaultIcon)
                                         .resizable()
                                         .frame(width: buttonConfig.size.width, height: buttonConfig.size.height)
                                         .foregroundColor(buttonConfig.tint)
                                     
                                    
                                 } else {
                                     Text(currentValue(for: buttonConfig.type))
                                         .font(.system(size: 16))
                                         .foregroundColor(.primary)
                                         .lineLimit(1)
                                         .minimumScaleFactor(0.7)
                                 }
                             }
                             .padding(2)
                             
                         }
                         Image(systemName: "chevron.down")
                             .resizable()
                             .frame(width: 12, height: 8)
                     }
                 }
                 .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    /// Retrieves the current value for the dropdown type.
    private func currentValue(for type: RichTextToolbarConfig.ButtonType) -> String {
        switch type {
        case .fontPicker:
            return getFontWeightName()
        case .textColorPicker:
            return "Color" // You can return a color name or value
        case .backgroundColorPicker:
            return "Background"
        case .cIndentMenu:
            return "Indent"
        default:
            return ""
        }
    }

    private func getFontWeightName() -> String {
        return viewModel.fontWeights.first(where: { $0.value == viewModel.selectedFontWeight })?.key ?? "Regular"
    }
    
    /// Handles dropdown button actions to toggle their visibility states.
    private func handleDropdownAction(for type: RichTextToolbarConfig.ButtonType) {
        switch type {
        case .fontPicker:
            viewModel.showFontPickerMenu.toggle()
        case .textColorPicker:
            viewModel.showingTextColorPicker.toggle()
            viewModel.showingBackgroundColorPicker = false
        case .backgroundColorPicker:
            viewModel.showingBackgroundColorPicker.toggle()
            viewModel.showingTextColorPicker = false
        case .insertImage: viewModel.toggleImagePickerDropdown()
        default:
            break
        }
    }

    /// Creates a menu button.
    private func menuButton(for buttonConfig: RichTextToolbarConfig.ButtonConfig, menuButtons: [RichTextToolbarConfig.ButtonConfig]) -> some View {
        Menu {
            ForEach(menuButtons) { menuButton in
                Button(action: {
                    handleAction(for: menuButton.type)
                }) {
                    Label(menuButton.type.displayName, systemImage: menuButton.defaultIcon)
                }
            }
        } label: {
            
            if let image = buttonConfig.icon {
                Image(image)
                    .resizable()
                    .frame(width: buttonConfig.size.width, height: buttonConfig.size.height)
            } else {
                
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .frame(width: buttonConfig.size.width, height: buttonConfig.size.height)
                    .foregroundColor(buttonConfig.tint)
            }
        }
    }

    /// Handles the action triggered by a button press.
    private func handleAction(for type: RichTextToolbarConfig.ButtonType) {
        switch type {
        case .undo: viewModel.undo()
        case .redo: viewModel.redo()
        case .bold: viewModel.toggleBold()
        case .italic: viewModel.toggleItalic()
        case .underline: viewModel.toggleUnderline()
        case .strikethrough: viewModel.toggleStrikethrough()
        case .alignLeft: viewModel.alignLeft()
        case .alignCenter: viewModel.alignCenter()
        case .alignRight: viewModel.alignRight()
        case .bulletList: viewModel.toggleBulletList()
        case .numberedList: viewModel.toggleNumberedList()
        case .addQuote: viewModel.toggleQuote()
        case .codeSnippet: viewModel.addCodeSnippet()
        case .insertImage: viewModel.toggleImagePickerDropdown()
        case .cameraPicker: viewModel.showCameraPicker()
        case .photoLibraryPicker:  viewModel.showPhotoLibraryPicker()
        case .insertFile: viewModel.showFilePicker()
        case .textColorPicker: viewModel.showTextForegroundColorPicker()
        case .backgroundColorPicker: viewModel.showTextBackgroundColorPicker()
        case .hyperlink:
            viewModel.isHyperlinkPromptPresented = true
            viewModel.hyperlinkURL = "" // Reset previous URL input

        case .hashtags: viewModel.toggleHashtag()
        case .angleBrackets: viewModel.styleAngleBrackets()
        case .fontPicker: viewModel.showFontPickerMenu.toggle()
        case .cIndentMenu: viewModel.showCIndentMenu.toggle()
        }
    }
}
