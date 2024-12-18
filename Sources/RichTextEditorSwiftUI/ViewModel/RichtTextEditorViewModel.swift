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
    
    public init() {
        // No additional setup needed for now
    }
    
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

    var fontSize: CGFloat = UIFont.systemFontSize
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
    
    @Published var isHyperlinkPromptPresented = false
    @Published var hyperlinkURL: String = ""
    @Published var hyperlinkColorFromCOnfig: UIColor = .link
    @Published var hashtagColorFromConfig: UIColor = .lightGray

    @Published var isBulletingActive = false
    @Published var isNumberedBulletActive = false
    @Published var needsUpdate = false

    
    private var currentBulletNumber = 1
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


    var currentAttributes: [NSAttributedString.Key: Any] {
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: selectedFont.withSize(fontSize)
        ]

        // Apply font family and weight
        if let fontName = selectedFontFamily as String?,
           let font = UIFont(name: fontName, size: UIFont.systemFontSize)?.withWeight(selectedFontWeight) {
            attributes[.font] = font
        }
        
        // Combine Bold and Italic traits using UIFontDescriptor
         var traits: UIFontDescriptor.SymbolicTraits = []
         if isBold { traits.insert(.traitBold) }
         if isItalic { traits.insert(.traitItalic) }
        var baseFont = attributes[.font] as? UIFont ??  selectedFont.withWeight(selectedFontWeight).withSize(fontSize)
         if let descriptor = baseFont.fontDescriptor.withSymbolicTraits(traits) {
             baseFont = UIFont(descriptor: descriptor, size: fontSize)
         }

         attributes[.font] = baseFont
        
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
        saveStateForUndo()
        isBold.toggle()
        applyFormatting()
    }

    func toggleItalic() {
        saveStateForUndo()
        isItalic.toggle()
        applyFormatting()
    }

    func toggleUnderline() {
        saveStateForUndo()
        isUnderline.toggle()
        applyFormatting()
    }

    func toggleStrikethrough() {
        saveStateForUndo()
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
    
    // MARK: - Undo & Redo
    func saveStateForUndo() {
        if undoStack.last != text {
            undoStack.append(text) // Save current text state
            redoStack.removeAll() // Clear redoStack on new action
        }
    }

    
    func undo() {
        guard let lastState = undoStack.popLast() else { return }
        redoStack.append(text) // Save current state to redoStack
        text = lastState // Restore the previous state
    }

    func redo() {
        guard let nextState = redoStack.popLast() else { return }
        undoStack.append(text) // Save current state to undoStack
        text = nextState // Restore the redone state
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
    
    // MARK: - Add Bullet at the New Line
    // Toggles circle bullets
    func toggleBulletList() {
        if isBulletingActive {
            resetBulletState()

        } else {
            isBulletingActive = true
            isNumberedBulletActive = false
            moveToNextLineAndAddBullet()
        }
        
    }

    // Toggles numbered bullets
    func toggleNumberedList() {
        if isBulletingActive && isNumberedBulletActive {
            resetBulletState()
        } else {
            isBulletingActive = true
            isNumberedBulletActive = true
            moveToNextLineAndAddBullet()
        }
        
    }

    // Stops bulleting state
    func resetBulletState() {
        isBulletingActive = false
        isNumberedBulletActive = false
        currentBulletNumber = 1
    }

    // Move to the next line and insert the first bullet
    private func moveToNextLineAndAddBullet() {
        let mutableText = NSMutableAttributedString(attributedString: text)
        let cursorPosition = selectedRange.location

        // Add newline + bullet text
        let bulletText = isNumberedBulletActive ? "\n\(currentBulletNumber). " : "\n• "
        if isNumberedBulletActive { currentBulletNumber += 1 }

        mutableText.insert(NSAttributedString(string: bulletText), at: cursorPosition)

        // Update text and set cursor position after bullet
        text = mutableText
        selectedRange = NSRange(location: cursorPosition + bulletText.count, length: 0)
    }

    // Inserts the next bullet or stops bulleting on empty line or double space
    func handleBulletOnReturnKey(at cursorPosition: Int) {
        let mutableText = NSMutableAttributedString(attributedString: text)
        let textLength = mutableText.length

        // Check for double Enter or double Space
        if cursorPosition >= 2 {
            let safeRange = NSRange(location: cursorPosition - 2, length: 2)
            if safeRange.upperBound <= textLength {
                let lastTwoChars = (mutableText.string as NSString).substring(with: safeRange)
                
                if lastTwoChars == "\n\n" || lastTwoChars == "  " {
                    resetBulletState() // Stop bulleting
                    return
                }
            }
        }

        // Add the next bullet if bulleting is active
        if isBulletingActive {
            let bulletText: String
            if isNumberedBulletActive {
                bulletText = "\n\(currentBulletNumber). "
                currentBulletNumber += 1
            } else {
                bulletText = "\n• "
            }

            // Safely insert the bullet at the cursor position
            let safePosition = min(cursorPosition, textLength)
            mutableText.insert(NSAttributedString(string: bulletText), at: safePosition)

            // Update text and cursor position
            text = mutableText
            selectedRange = NSRange(location: safePosition + bulletText.count, length: 0)
        }
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
           let codeSnippetText = selectedRange.length > 0 ? (text.string as NSString).substring(with: selectedRange) : "Code snippet"
           let attributedCodeSnippet = NSAttributedString(
               string: codeSnippetText,
               attributes: [.font: UIFont(name: "Courier", size: 14) ?? UIFont.systemFont(ofSize: 14)]
           )
           updateText(with: attributedCodeSnippet)
       }
    
    func toggleQuote() {
        saveStateForUndo()
        
        let mutableText = NSMutableAttributedString(attributedString: text)
        let cursorPosition = selectedRange.location
        
        if selectedRange.length > 0 {
            // Wrap selected text with quotes
            let selectedText = (mutableText.string as NSString).substring(with: selectedRange)
            let quotedText = "\"\(selectedText)\""
            mutableText.replaceCharacters(in: selectedRange, with: quotedText)
            
            // Apply formatting to the quoted text
            let updatedRange = NSRange(location: selectedRange.location, length: quotedText.count)
            applyQuoteFormatting(to: mutableText, in: updatedRange)
            
            // Move cursor inside the quotes
            selectedRange = NSRange(location: selectedRange.location + 1, length: selectedText.count)
        } else {
            // Insert quotes at cursor position
            mutableText.insert(NSAttributedString(string: "\"\""), at: cursorPosition)
            
            // Apply formatting to the empty quotes
            let updatedRange = NSRange(location: cursorPosition, length: 2)
            applyQuoteFormatting(to: mutableText, in: updatedRange)
            
            // Move cursor inside the quotes
            selectedRange = NSRange(location: cursorPosition + 1, length: 0)
        }
        
        text = mutableText
    }
    
    private func applyQuoteFormatting(to text: NSMutableAttributedString, in range: NSRange) {
        text.addAttributes([
            .foregroundColor: UIColor.systemGray, // Custom color for quotes
            .font: UIFont.italicSystemFont(ofSize: 14) // Italic font for quotes
        ], range: range)
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

        let clampedRange = NSRange(
            location: min(selectedRange.location, text.length),
            length: min(selectedRange.length, text.length - selectedRange.location)
        )

        saveStateForUndo()
        var updatedAttributes = currentAttributes

        // Combine bold and italic traits dynamically
        var currentFont = updatedAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: fontSize)
        currentFont = fontWithTraits(baseFont: currentFont, bold: isBold, italic: isItalic)
        updatedAttributes[.font] = currentFont

        // Underline and Strikethrough
        if isUnderline {
            updatedAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        } else {
            updatedAttributes.removeValue(forKey: .underlineStyle)
        }
        if isStrikethrough {
            updatedAttributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        } else {
            updatedAttributes.removeValue(forKey: .strikethroughStyle)
        }

        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.addAttributes(updatedAttributes, range: clampedRange)
        text = mutableText

    }
    
    private func resetFormattingStates() {
        isBold = false
        isItalic = false
        isUnderline = false
        isStrikethrough = false
    }
    
    
    func fontWithTraits(baseFont: UIFont, bold: Bool, italic: Bool) -> UIFont {
        var traits: UIFontDescriptor.SymbolicTraits = []
        if bold { traits.insert(.traitBold) }
        if italic { traits.insert(.traitItalic) }

        guard let descriptor = baseFont.fontDescriptor.withSymbolicTraits(traits) else {
            return baseFont
        }
        return UIFont(descriptor: descriptor, size: baseFont.pointSize)
    }
    
    func updateTypingAttributes(for textView: UITextView) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        var baseFont = UIFont.systemFont(ofSize: fontSize)
        
        // Combine Bold and Italic traits
        baseFont = fontWithTraits(baseFont: baseFont, bold: isBold, italic: isItalic)
        attributes[.font] = baseFont

        // Apply underline and strikethrough
        if isUnderline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        if isStrikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }

        // Update the textView's typing attributes
        textView.typingAttributes = attributes
    }
    
    
    var activeAttributes: [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        var baseFont = UIFont.systemFont(ofSize: fontSize)

        // Apply Bold and Italic traits
        var traits: UIFontDescriptor.SymbolicTraits = []
        if isBold { traits.insert(.traitBold) }
        if isItalic { traits.insert(.traitItalic) }
        
        if let descriptor = baseFont.fontDescriptor.withSymbolicTraits(traits) {
            baseFont = UIFont(descriptor: descriptor, size: fontSize)
        }

        attributes[.font] = baseFont

        // Apply Underline and Strikethrough
        if isUnderline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        if isStrikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }

        return attributes
    }
    
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
    
    func addHyperlink(urlString: String) {
        guard selectedRange.length > 0 else { return }
        
        var validURLString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Add scheme if missing
        if !validURLString.lowercased().hasPrefix("http://") && !validURLString.lowercased().hasPrefix("https://") {
            validURLString = "https://\(validURLString)"
        }
        
        // Validate the URL
        guard let url = URL(string: validURLString) else { return }
        
        saveStateForUndo()
        
        let mutableText = NSMutableAttributedString(attributedString: text)
        
        // Apply hyperlink attributes to the selected range
        mutableText.addAttributes([
            .link: url,
//            .foregroundColor: hyperlinkColorFromCOnfig,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: selectedRange)
        
        // Insert a non-hyperlinked space after the selected range
        let space = NSAttributedString(string: " ", attributes: [:])
        let insertionIndex = selectedRange.location + selectedRange.length
        mutableText.insert(space, at: insertionIndex)
        
        text = mutableText
        
        // Move the cursor to just after the inserted space
        selectedRange = NSRange(location: insertionIndex + 1, length: 0)
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

extension RichTextEditorViewModel {
    
    // Validators
      private func isValidURL(_ string: String) -> Bool {
          guard let url = URL(string: string) else { return false }
          return UIApplication.shared.canOpenURL(url)
      }

      private func isValidHashtag(_ string: String) -> Bool {
          let regex = "^#[a-zA-Z0-9_]+$"
          return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: string)
      }
    
    // Apply attributes to selected text or append new attributes
    // MARK: - Rich Text Actions
       func addHyperlink(_ urlString: String) {
           guard isValidURL(urlString) else { return }
           saveStateForUndo()

           let hyperlinkText = selectedRange.length > 0 ? (text.string as NSString).substring(with: selectedRange) : "Hyperlink"
           let attributedHyperlink = NSAttributedString(
               string: hyperlinkText,
               attributes: [.link: URL(string: urlString)!,/*.foregroundColor: hyperlinkColorFromCOnfig,*/ .underlineStyle: NSUnderlineStyle.single.rawValue]
           )
           updateText(with: attributedHyperlink)
       }

    func toggleHashtag() {
        saveStateForUndo()
        
        let mutableText = NSMutableAttributedString(attributedString: text)
        let cursorPosition = selectedRange.location

        if selectedRange.length > 0 {
            // Wrap selected text with a hashtag
            let selectedText = (mutableText.string as NSString).substring(with: selectedRange)
            let hashtaggedText = "#\(selectedText)"
            mutableText.replaceCharacters(in: selectedRange, with: hashtaggedText)
            
            // Apply formatting to the hashtag
            let updatedRange = NSRange(location: selectedRange.location, length: hashtaggedText.count)
            applyHashtagFormatting(to: mutableText, in: updatedRange)
            
            selectedRange = NSRange(location: selectedRange.location + 1, length: selectedText.count)
        } else {
            // Insert "#" at the cursor position
            let hashtag = NSAttributedString(string: "#", attributes: [:])
            mutableText.insert(hashtag, at: cursorPosition)
            selectedRange = NSRange(location: cursorPosition + 1, length: 0)
        }
        
        text = mutableText
    }
    
    private func applyHashtagFormatting(to text: NSMutableAttributedString, in range: NSRange) {
        text.addAttributes([
            .foregroundColor: UIColor.darkGray,//hashtagColorFromConfig,
            .font: selectedFont.withWeight(selectedFontWeight).withSize(fontSize)
        ], range: range)
    }

       // Helper: Update selected text or append if no selection
       private func updateText(with attributedString: NSAttributedString) {
           let mutableText = NSMutableAttributedString(attributedString: text)

           if selectedRange.length > 0 {
               mutableText.replaceCharacters(in: selectedRange, with: attributedString)
           } else {
               mutableText.append(attributedString)
           }

           text = mutableText
       }
    
}

//MARK: - textViewDidChange and - textViewDidChangeSelection
extension RichTextEditorViewModel {
    
    func applyRealTimeHashtagFormatting(to text: NSMutableAttributedString, hashtagColor: UIColor, cursorPosition: Int) {
        let fullText = text.string as NSString
        let hashtagRegex = try! NSRegularExpression(pattern: "#\\w+", options: [])

        // Step 1: Detect hashtags
        let matches = hashtagRegex.matches(in: fullText as String, options: [], range: NSRange(location: 0, length: fullText.length))

        // Step 2: Iterate over all detected hashtags
        for match in matches {
            let hashtagRange = match.range

            // Protect the hashtag if the cursor is inside or immediately after it
            if NSLocationInRange(cursorPosition - 1, hashtagRange) {
                let safeRange = NSRange(location: cursorPosition - 1, length: 1)
                if safeRange.upperBound <= text.length {
                    text.removeAttribute(.foregroundColor, range: safeRange)
                    text.removeAttribute(.font, range: safeRange)
                }
            }

            // Step 3: Reapply hashtag formatting
            text.addAttributes([
//                .foregroundColor: hashtagColor,
                .font:  selectedFont.withWeight(selectedFontWeight).withSize(fontSize)
            ], range: hashtagRange)
        }
    }
    
    func applyRealTimeQuoteFormatting(to text: NSMutableAttributedString) {
        let fullText = text.string
           var startQuoteIndex: Int? = nil

           for (index, char) in fullText.enumerated() {
               if char == "\"" {
                   if let start = startQuoteIndex {
                       // Found a closing quote, format the text between the quotes
                       let range = NSRange(location: start + 1, length: index - start - 1)
                       if range.length > 0 {
                           text.addAttributes([
                               .foregroundColor: UIColor.systemGray,
                               .font:  selectedFont.withWeight(selectedFontWeight).withSize(fontSize)
                           ], range: range)
                       }
                       startQuoteIndex = nil // Reset
                   } else {
                       // Found an opening quote
                       startQuoteIndex = index
                   }
               }
           }
    }
    
    func handleHyperlinkRemoval(mutableText: NSMutableAttributedString, cursorPosition: Int, textView: UITextView, hyperlinkColor: UIColor) {
        // If cursor is within or just after a hyperlink, remove hyperlink attribute
        if cursorPosition > 0 {
            let previousAttributes = mutableText.attributes(at: cursorPosition - 1, effectiveRange: nil)

            if previousAttributes[.link] != nil {
                let rangeToRemove = NSRange(location: cursorPosition - 1, length: 1)
                mutableText.removeAttribute(.link, range: rangeToRemove)
            }
        }

        // Re-apply hyperlink color formatting for remaining hyperlinks
        mutableText.enumerateAttribute(.link, in: NSRange(location: 0, length: mutableText.length), options: []) { value, range, _ in
            if value != nil {
                mutableText.addAttributes([
//                    .foregroundColor: hyperlinkColor,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ], range: range)
            }
        }

        // Update the textView
        textView.attributedText = mutableText
        textView.selectedRange = NSRange(location: cursorPosition, length: 0) // Adjust cursor position
    }
    
}

