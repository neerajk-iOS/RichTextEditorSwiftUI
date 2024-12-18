//
//  Extension+NSMutableString.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//
import Foundation
import UIKit

    // MARK: - Extensions
extension NSMutableAttributedString {
    func appending(attributedString: NSAttributedString) -> NSMutableAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        copy.append(attributedString)
        return copy
    }
}


public extension NSAttributedString {
    static func richContentExample() -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()

        // Adding Bold Text
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        mutableAttributedString.append(NSAttributedString(string: "Rich Text Example\n", attributes: [.font: boldFont]))

        // Adding Bullet List
        let bulletList = [
            "• Item 1\n",
            "• Item 2\n",
            "• Item 3\n"
        ]
        for item in bulletList {
            mutableAttributedString.append(NSAttributedString(string: item))
        }

        // Adding Hyperlink
        let hyperlink = NSAttributedString(string: "Visit Example.com\n", attributes: [
            .link: URL(string: "https://example.com")!,
            .foregroundColor: UIColor.link
        ])
        mutableAttributedString.append(hyperlink)

        // Adding an Image Attachment
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "photo") // Example system image
        let imageString = NSAttributedString(attachment: attachment)
        mutableAttributedString.append(imageString)
        mutableAttributedString.append(NSAttributedString(string: "\n"))

        // Adding Code Snippet
        let codeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Courier", size: 14) ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.systemGray
        ]
        mutableAttributedString.append(NSAttributedString(string: "let codeSnippet = \"Hello, World!\"\n", attributes: codeAttributes))

        return mutableAttributedString
    }
}
