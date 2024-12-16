//
//  PickerSheetConfig.swift
//  RichText
//
//  Created by Neeraj Kumar on 16/12/24.
//
import SwiftUI


/// Configuration for customizing the sheet behavior.
public struct PickerSheetConfig {
    public var detents: Set<PresentationDetent> = [.medium, .large]
    public var backgroundColor: Color = Color.white.opacity(0.9)
    public var blurEffect: Bool = true

    public init(detents: Set<PresentationDetent> = [.medium, .large],
                backgroundColor: Color = Color.white.opacity(0.9),
                blurEffect: Bool = true) {
        self.detents = detents
        self.backgroundColor = backgroundColor
        self.blurEffect = blurEffect
    }
}
