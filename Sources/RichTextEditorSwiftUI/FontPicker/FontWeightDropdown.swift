//
//  FontWeightDropdown 2.swift
//  RichText
//
//  Created by Neeraj Kumar on 13/12/24.
//
import SwiftUI

/// A dropdown component for selecting font weights.
struct FontWeightDropdown: View {
    @ObservedObject var viewModel: RichTextEditorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Font Weight")
                .font(.caption)
                .padding(.bottom, 4)

            Menu {
                ForEach(viewModel.fontWeights.keys.sorted(), id: \.self) { weightName in
                    Button(action: {
                        if let weight = viewModel.fontWeights[weightName] {
                            viewModel.setFontWeight(weight)
                        }
                    }) {
                        HStack {
                            Text(weightName)
                                .font(.system(size: 16, weight: Font.Weight.fromUIFontWeight(viewModel.fontWeights[weightName] ?? .regular)))
                            if viewModel.selectedFontWeight == viewModel.fontWeights[weightName] {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.fontWeights.first(where: { $0.value == viewModel.selectedFontWeight })?.key ?? "Regular")
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
        }
    }
    
    private func weightsForFont(_ fontName: String) -> [UIFont.Weight] {
        guard let baseFont = UIFont(name: fontName, size: UIFont.systemFontSize) else {
            return []
        }

        let availableWeights: [UIFont.Weight] = [
            .ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black
        ]
        
        var supportedWeights: [UIFont.Weight] = []
        
        for weight in availableWeights {
            if let testFont = UIFont(name: fontName, size: UIFont.systemFontSize)?.withWeight(weight) {
                // If font creation succeeds with the weight, add to supported weights
                supportedWeights.append(weight)
            }
        }
        return supportedWeights
    }
}
