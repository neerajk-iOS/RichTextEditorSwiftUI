//
//  CameraImagePicker.swift
//  RixhTextDemo
//
//  Created by Neeraj Kumar on 10/12/24.
//

import SwiftUI

// MARK: - Legacy Camera Picker (UIImagePickerController)

/// A SwiftUI wrapper around UIImagePickerController for capturing images via the camera.
///
/// Usage:
/// ```swift
/// CameraImagePicker(image: $image, sourceType: .camera)
/// ```
public struct CameraImagePicker: UIViewControllerRepresentable {
    let onImagePicked: (UIImage) -> Void // Callback for the selected image
    var sourceType: UIImagePickerController.SourceType

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraImagePicker

        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            picker.dismiss(animated: true)
        }

        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}


struct ImagePickerOptionsView: View {
    @ObservedObject var viewModel: RichTextEditorViewModel

    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                viewModel.showCameraPicker()
            }) {
                HStack {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Camera")
                        .font(.body)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
            
            Button(action: {
                viewModel.showPhotoLibraryPicker()
            }) {
                HStack {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Photo Library")
                        .font(.body)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
