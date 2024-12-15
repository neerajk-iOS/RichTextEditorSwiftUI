//
//  RichtTextEditorViewModel.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//
import SwiftUI

enum PickerType {
    case textColorPicker
    case backgroundColorPicker
}
    // MARK: - RichTextEditorViewModel
public class RichTextEditorViewModel: ObservableObject {
    @Published var text = NSAttributedString(string: "Type here...")
    @Published var isBold = false
    @Published var isItalic = false
    @Published var isUnderline = false
    @Published var isStrikethrough = false
    @Published var isPickerPresented = false
    @Published var isFilePickerPresented = false
    @Published var isCameraPickerPresented = false
    @Published var isPhotoLibraryPickerPresented = false
    @Published var showingImagePickerDropdown = false // Tracks visibility of the Image Picker dropdown

    private var fontSize: CGFloat = UIFont.systemFontSize
    @Published var textForegroundColor: UIColor = .black
    @Published var textBackgroundColor: UIColor = .white
    
    @Published var undoStack: [NSAttributedString] = []
    @Published var redoStack: [NSAttributedString] = []
    @Published var selectedRange: NSRange = NSRange(location: 0, length: 0)
    
    @Published var showingTextColorPicker = false
    @Published var showingBackgroundColorPicker = false
    
    @Published var selectedFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    @Published var showingFontPicker = false
    
    @Published var showFontPickerMenu = false
    @Published var showCIndentMenu = false
    @Published var availableFonts: [String] = UIFont.familyNames
    @Published var selectedFontFamily: String = UIFont.systemFont(ofSize: UIFont.systemFontSize).familyName
    @Published var selectedFontWeight: UIFont.Weight = .regular

    // New Font Weights Section
       let fontWeights: [String: UIFont.Weight] = [
           "Regular": .regular,
           "Bold": .bold,
           "Heavy": .heavy,
           "Light": .light,
           "Medium": .medium,
           "Semibold": .semibold,
           "Thin": .thin,
           "Black": .black,
           "UltraLight": .ultraLight
       ]


    private var currentAttributes: [NSAttributedString.Key: Any] {
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: selectedFont.withSize(fontSize)
        ]

        // Apply font family and weight
        if let fontName = selectedFontFamily as String?,
           let font = UIFont(name: fontName, size: UIFont.systemFontSize)?.withWeight(selectedFontWeight) {
            attributes[.font] = font
        }
        
        if isBold {
            attributes[.font] = UIFont.boldSystemFont(ofSize: fontSize)
        }
        
        if isItalic {
            attributes[.obliqueness] = 0.3
        }
        
        if isUnderline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        if isStrikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        
        attributes[.backgroundColor] = textBackgroundColor
        
        attributes[.foregroundColor] = textForegroundColor
        
        
        return attributes
    }
    
    // Expose getters for private variables
    public var isFontPickerMenuVisible: Bool {
        return showFontPickerMenu
    }
    
    public var isTextColorPickerVisible: Bool {
        return showingTextColorPicker
    }
    
    public var isBackgroundColorPickerVisible: Bool {
        return showingBackgroundColorPicker
    }
    
    
    func toggleBold() {
        isBold.toggle()
        applyFormatting()
    }
    
    func toggleItalic() {
        isItalic.toggle()
        applyFormatting()
    }
    
    func toggleUnderline() {
        isUnderline.toggle()
        applyFormatting()
    }
    
    func toggleStrikethrough() {
        isStrikethrough.toggle()
        applyFormatting()
    }
    
    func increaseFontSize() {
        fontSize += 2
        applyFormatting()
    }
    
    func decreaseFontSize() {
        fontSize = max(2, fontSize - 2)
        applyFormatting()
    }
    
    func showTextForegroundColorPicker() {
        showingTextColorPicker = true
    }
    
    func showTextBackgroundColorPicker() {
        showingBackgroundColorPicker = true
    }
    
    func setTextForegroundColor(_ color: UIColor) {
        textForegroundColor = color
        applyFormatting()
    }
    
    func getTextForegroundColor() -> UIColor? {
        return textForegroundColor
    }
    
    func setTextBackgroundColor(_ color: UIColor) {
        textBackgroundColor = color
        applyFormatting()
    }
    
    func undo() {
        guard let lastState = undoStack.popLast() else { return }
        redoStack.append(text)
        text = lastState
    }
    
    func redo() {
        guard let lastState = redoStack.popLast() else { return }
        undoStack.append(text)
        text = lastState
    }
    
    private func saveStateForUndo() {
        undoStack.append(text)
        redoStack.removeAll()
    }
    
    func alignLeft() {
        applyParagraphStyle { style in
            style.alignment = .left
        }
    }
    
    func alignCenter() {
        applyParagraphStyle { style in
            style.alignment = .center
        }
    }
    
    func alignRight() {
        applyParagraphStyle { style in
            style.alignment = .right
        }
    }
    
    func addBulletList() {
        let bullet = "• "
        addListPrefix(bullet)
    }
    
    func addNumberedList() {
        let number = "1. " // Update dynamically for numbers
        addListPrefix(number)
    }
    
    func indent() {
        applyParagraphStyle { style in
            style.firstLineHeadIndent += 20
            style.headIndent += 20
        }
    }
    
    func outdent() {
        applyParagraphStyle { style in
            style.firstLineHeadIndent = max(0, style.firstLineHeadIndent - 20)
            style.headIndent = max(0, style.headIndent - 20)
        }
    }
    
    func showFilePicker() {
        isFilePickerPresented = true
    }
    
    func addCodeSnippet() {
        let codeSnippet = NSAttributedString(string: "Code snippet", attributes: [.font: UIFont(name: "Courier", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)])
        text = NSMutableAttributedString(attributedString: text).appending(attributedString: codeSnippet)
    }
    
    func addQuote() {
        let quote = NSAttributedString(string: "\"Quote\"", attributes: [.font: UIFont.italicSystemFont(ofSize: fontSize)])
        text = NSMutableAttributedString(attributedString: text).appending(attributedString: quote)
    }
    
    /// Toggles the visibility of the Image Picker dropdown
    func toggleImagePickerDropdown() {
        showingImagePickerDropdown.toggle()
    }

    /// Shows the Camera Picker sheet
    func showCameraPicker() {
        showingImagePickerDropdown = false // Hide the dropdown
        isCameraPickerPresented = true
    }

    /// Shows the Photo Library Picker sheet
    func showPhotoLibraryPicker() {
        showingImagePickerDropdown = false // Hide the dropdown
        isPhotoLibraryPickerPresented = true
    }
    
    func insertImage(_ image: UIImage) {
            // Logic to insert the image into the attributed string
            let attachment = NSTextAttachment()
            attachment.image = image
            let attributedString = NSAttributedString(attachment: attachment)

            let mutableText = NSMutableAttributedString(attributedString: text)
            mutableText.append(attributedString)
            text = mutableText
        }
    
    func insertFile(_ fileURL: URL) {
        let fileText = NSAttributedString(string: "[File: \(fileURL.lastPathComponent)]")
        text = NSMutableAttributedString(attributedString: text).appending(attributedString: fileText)
    }
    
    func applyFormatting() {
        guard selectedRange.location != NSNotFound else { return }

        // Clamp the range to valid bounds of the text
        let clampedRange = NSRange(
            location: min(selectedRange.location, text.length),
            length: min(selectedRange.length, text.length - selectedRange.location)
        )

        saveStateForUndo()

        // Update current attributes with selected font family and weight
        var updatedAttributes = currentAttributes

        if let fontName = selectedFontFamily as String?,
           let newFont = UIFont(name: fontName, size: UIFont.systemFontSize)?.withWeight(selectedFontWeight) {
            updatedAttributes[.font] = newFont
        }

        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.addAttributes(updatedAttributes, range: clampedRange)
        text = mutableText
    }
    
//    func applyFormatting() {
//        saveStateForUndo()
//        
//        
//        
//            // Check if no text is selected (cursor is just placed somewhere)
//        if selectedRange.length == 0 {
//                // Apply formatting starting from the current cursor position to the end of the typed text
//            let updatedText = NSMutableAttributedString(attributedString: text)
//            let rangeToUpdate = NSRange(location: selectedRange.location, length: updatedText.length - selectedRange.location)
//            updatedText.addAttributes(currentAttributes, range: rangeToUpdate)
//            text = updatedText
//        } else {
//                // Apply formatting to the selected text
//            let updatedText = NSMutableAttributedString(attributedString: text)
//            updatedText.addAttributes(currentAttributes, range: selectedRange)
//            text = updatedText
//        }
//    }
    
    private func applyParagraphStyle(_ update: (NSMutableParagraphStyle) -> Void) {
        let updatedText = NSMutableAttributedString(attributedString: text)
        let paragraphStyle = NSMutableParagraphStyle()
        update(paragraphStyle)
        updatedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.length))
        text = updatedText
    }
    
    private func addListPrefix(_ prefix: String) {
        let updatedText = NSMutableAttributedString(attributedString: text)
        updatedText.insert(NSAttributedString(string: prefix), at: 0)
        text = updatedText
    }
    
    func addHyperlink() {
          let url = "https://example.com"
          let hyperlink = NSAttributedString(
              string: "Hyperlink",
              attributes: [
                  .link: URL(string: url)!,
                  .underlineStyle: NSUnderlineStyle.single.rawValue
              ]
          )
          text = NSMutableAttributedString(attributedString: text).appending(attributedString: hyperlink)
      }

      func styleHashtags() {
          let regex = try! NSRegularExpression(pattern: "#\\w+")
          let matches = regex.matches(in: text.string, range: NSRange(location: 0, length: text.length))

          let mutableText = NSMutableAttributedString(attributedString: text)
          for match in matches {
              mutableText.addAttributes([
                  .foregroundColor: UIColor.systemBlue,
                  .font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
              ], range: match.range)
          }
          text = mutableText
      }

      func styleAngleBrackets() {
          let regex = try! NSRegularExpression(pattern: "<.*?>")
          let matches = regex.matches(in: text.string, range: NSRange(location: 0, length: text.length))

          let mutableText = NSMutableAttributedString(attributedString: text)
          for match in matches {
              mutableText.addAttributes([
                  .foregroundColor: UIColor.systemGray,
                  .font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
              ], range: match.range)
          }
          text = mutableText
      }

      func setFont(_ fontName: String) {
          let newFont = UIFont(name: fontName, size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
          let mutableText = NSMutableAttributedString(attributedString: text)
          mutableText.addAttribute(.font, value: newFont, range: NSRange(location: 0, length: text.length))
          text = mutableText
      }
    
    // Updated to apply both font family and weight
       func applySelectedFont(fontName: String, weight: UIFont.Weight) {
           let descriptor = UIFontDescriptor(name: fontName, size: UIFont.systemFontSize)
           let weightedFont = UIFont(descriptor: descriptor.withSymbolicTraits(.traitBold) ?? descriptor, size: UIFont.systemFontSize)
           selectedFont = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: weight)
           applyFormatting()
       }
    
    func setFontFamily(_ family: String) {
           selectedFontFamily = family
           applyFormatting()
       }

       func setFontWeight(_ weight: UIFont.Weight) {
           selectedFontWeight = weight
           applyFormatting()
       }
    
}
