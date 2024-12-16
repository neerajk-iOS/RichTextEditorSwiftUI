//
//  RichTextViewer.swift
//  RichText
//
//  Created by Neeraj Kumar on 16/12/24.
//

import SwiftUI
import UIKit

/// A viewer for displaying rich text content with all supported attributes like images, hyperlinks, etc.
public struct RichTextViewer: View {
    private let attributedString: NSAttributedString
    private let showAttributes: Bool

    /// Initialize the RichTextViewer
    /// - Parameters:
    ///   - attributedString: The formatted `NSAttributedString` to display.
    ///   - showAttributes: A flag to optionally display text attributes for debugging.
    public init(attributedString: NSAttributedString, showAttributes: Bool = false) {
        self.attributedString = attributedString
        self.showAttributes = showAttributes
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Rich Content Viewer
            AttributedTextView(attributedString: attributedString)
                .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                .border(Color.gray.opacity(0.5))
                .padding()

            if showAttributes {
                Divider()
                Text("Attributes:")
                    .font(.headline)

                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(extractAttributeDetails(), id: \.self) { detail in
                            Text(detail)
                                .font(.caption)
                                .padding(.vertical, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(maxHeight: 200)
                .padding()
            }
        }
        .padding()
    }

    /// Extract attributes for display (debugging purpose)
    private func extractAttributeDetails() -> [String] {
        var details: [String] = []
        attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: []) { attributes, range, _ in
            let rangeString = "Range: \(range.location) - \(range.location + range.length)"
            var attributeDetails = [rangeString]

            for (key, value) in attributes {
                attributeDetails.append("   \(key.rawValue): \(value)")
            }
            details.append(attributeDetails.joined(separator: "\n"))
        }
        return details
    }
}
