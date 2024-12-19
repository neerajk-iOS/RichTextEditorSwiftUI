//
//  ButtonHighlightView.swift
//  RichText
//
//  Created by Neeraj Kumar on 19/12/24.
//

import SwiftUI

struct ButotnHighlightView: View {
    let color: Color
    var body: some View {
        Divider()
            .frame(height: 0.8)
            .foregroundStyle(color)
            .opacity(color == Color.clear ? 0 : 1)
    }
}
