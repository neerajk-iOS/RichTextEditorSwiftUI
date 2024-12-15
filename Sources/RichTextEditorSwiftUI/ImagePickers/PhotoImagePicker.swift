//
//  PhotoImagePicker.swift
//  SwiftPackage
//
//  Created by Neeraj Kumar on 10/12/24.
//
//  A modern SwiftUI wrapper around PHPickerViewController for image selection.
//  Designed for SwiftUI projects targeting iOS 14+.
//

import SwiftUI
import PhotosUI

// MARK: - Modern Photo Picker (PHPickerViewController)

/// A SwiftUI wrapper around PHPickerViewController for selecting photos.
/// Recommended for iOS 14+ as a modern replacement for UIImagePickerController.
///
/// Usage:
/// ```swift
/// PhotoLibraryPicker(selectedImage: $image)
/// ```
public struct PhotoLibraryPicker: UIViewControllerRepresentable {
    let onImagePicked: (UIImage) -> Void // Callback for the selected image

    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoLibraryPicker

        init(_ parent: PhotoLibraryPicker) {
            self.parent = parent
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.onImagePicked(image)
                        }
                    } else if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


enum ImageSourceType {
    case camera
    case photoLibrary
}
