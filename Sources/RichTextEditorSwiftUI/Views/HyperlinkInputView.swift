/// - Author: Neeraj Kumar
/// - Created: 13/12/24


import SwiftUI

struct HyperlinkInputView: View {
    @Binding var url: String
    var onSubmit: () -> Void
    
    var body: some View {
        VStack {
            TextField("Enter URL", text: $url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Add Hyperlink", action: onSubmit)
        }
        .padding()
    }
}
