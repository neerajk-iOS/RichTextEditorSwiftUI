//
//  RichTextToolbarConfig.swift
//  RichText
//
//  Created by Neeraj Kumar on 15/12/24.
//
import SwiftUI

// MARK: - RichTextToolbarConfig
public struct RichTextToolbarConfig {
    
    // MARK: - ButtonType Enum
    public enum ButtonType: CaseIterable {
        case undo, redo, bold, italic, underline, strikethrough
        case alignLeft, alignCenter, alignRight
        case bulletList, numberedList, addQuote, codeSnippet
        case insertImage, insertFile, textColorPicker, backgroundColorPicker
        case hyperlink, hashtags, angleBrackets, fontPicker, cIndentMenu
        case photoLibraryPicker, cameraPicker
        var defaultIcon: String {
            switch self {
            case .undo: return "arrow.uturn.left"
            case .redo: return "arrow.uturn.right"
            case .bold: return "bold"
            case .italic: return "italic"
            case .underline: return "underline"
            case .strikethrough: return "strikethrough"
            case .alignLeft: return "text.alignleft"
            case .alignCenter: return "text.aligncenter"
            case .alignRight: return "text.alignright"
            case .bulletList: return "list.bullet"
            case .numberedList: return "list.number"
            case .addQuote: return "quote.bubble"
            case .codeSnippet: return "curlybraces"
            case .insertImage: return "photo"
            case .insertFile: return "link"
            case .textColorPicker: return "pencil.tip"
            case .backgroundColorPicker: return "paintbrush"
            case .hyperlink: return "link.circle"
            case .hashtags: return "number"
            case .angleBrackets: return "chevron.left.slash.chevron.right"
            case .fontPicker: return "textformat"
            case .cIndentMenu: return "arrow.left.and.right"
            case .photoLibraryPicker: return "photo"
            case .cameraPicker: return "camera"
            }
        }

        var displayName: String {
            switch self {
            case .undo: return "Undo"
            case .redo: return "Redo"
            case .bold: return "Bold"
            case .italic: return "Italic"
            case .underline: return "Underline"
            case .strikethrough: return "Strikethrough"
            case .alignLeft: return "Align Left"
            case .alignCenter: return "Align Center"
            case .alignRight: return "Align Right"
            case .bulletList: return "Bullet List"
            case .numberedList: return "Numbered List"
            case .addQuote: return "Add Quote"
            case .codeSnippet: return "Code Snippet"
            case .insertImage: return "Insert Image"
            case .insertFile: return "Insert File"
            case .textColorPicker: return "Text Color"
            case .backgroundColorPicker: return "Background Color"
            case .hyperlink: return "Hyperlink"
            case .hashtags: return "Hashtags"
            case .angleBrackets: return "Angle Brackets"
            case .fontPicker: return "Font Picker"
            case .cIndentMenu: return "Indent Menu"
            case .photoLibraryPicker: return "Photo Library"
            case .cameraPicker: return "Camera"
            }
        }
    }

    // MARK: - ButtonBehavior Enum
    public struct ButtonConfig: Identifiable, Hashable {
        public let id = UUID()
        public let type: ButtonType
        public let icon: String
        public let buttonType: ButtonBehavior
        public let tint: Color
        public let size: CGSize

        public init(type: ButtonType,
                    icon: String? = nil,
                    buttonType: ButtonBehavior = .normal,
                    tint: Color = .primary,
                    size: CGSize = CGSize(width: 24, height: 24)) {
            self.type = type
            self.icon = icon ?? type.defaultIcon
            self.buttonType = buttonType
            self.tint = tint
            self.size = size
        }
    }

      public enum ButtonBehavior: Hashable {
          case normal
          case dropdown([ButtonConfig])
          case menu([ButtonConfig])
      }

      public var buttonGroups: [[ButtonConfig]]
      public var toolbarHeight: CGFloat
      public var spacing: CGFloat

      public init(buttonGroups: [[ButtonConfig]] = [],
                  toolbarHeight: CGFloat = 50,
                  spacing: CGFloat = 8) {
          self.buttonGroups = buttonGroups
          self.toolbarHeight = toolbarHeight
          self.spacing = spacing
      }
    
}
