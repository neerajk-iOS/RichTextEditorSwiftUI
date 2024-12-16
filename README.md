# RichTextEditorSwiftUI

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/swift-5.7-orange.svg)](https://swift.org/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

## Overview

`RichTextEditorSwiftUI` is a lightweight, customizable Swift Package that enables rich text editing in your iOS applications. It features an intuitive toolbar for managing text formatting, font customization, color pickers, and image/file insertion. This package is ideal for apps that require robust and flexible text editing capabilities.

### Features

- **Text Formatting**: Bold, italic, underline, strikethrough, font size, and alignment controls.
- **Font Picker**: Dropdown to select font families and weights.
- **Color Customization**: Easily pick text and background colors.
- **Media Support**: Insert images and files seamlessly.
- **Undo/Redo Functionality**: Maintain editing history.
- **Modular Toolbar**: Configure and customize buttons and dropdown menus.

---

## Installation

### Requirements

- **iOS**: 16.0 or later
- **Swift**: 5.7 or later

### Using Swift Package Manager

1. In Xcode, go to **File > Add Packages**.
2. Enter the repository URL: `https://github.com/your-username/RichTextEditorSwiftUI`.
3. Select the version and add it to your project.

---

## Usage

struct ContentView: View {
    @StateObject private var viewModel = RichTextEditorViewModel()
    
    var body: some View {
        RichTextView(toolbarConfig: getToolbarConfig())
            .environmentObject(viewModel)
            .padding()
    }
}

func getToolbarConfig() -> RichTextToolbarConfig {
    RichTextToolbarConfig(
        buttonGroups: [
            [.init(type: .undo), .init(type: .redo), .init(type: .bold)]
        ]
    )
}

### Basic Setup

1. Import the package:
   ```swift
   import RichTextEditorSwiftUI
