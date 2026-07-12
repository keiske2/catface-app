import SwiftUI
import PhotosUI
import UIKit
import Combine

class PhotoPickerManager: NSObject, ObservableObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Published var selectedImage: UIImage?
    var onImagePicked: ((UIImage) -> Void)?

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        defer { picker.dismiss(animated: true) }

        guard let image = info[.originalImage] as? UIImage else { return }
        let normalized = normalizeImage(image, maxSize: 640)
        self.selectedImage = normalized
        onImagePicked?(normalized)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func normalizeImage(_ image: UIImage, maxSize: CGFloat = 640) -> UIImage {
        let size = image.size
        let scale = min(maxSize / size.width, maxSize / size.height)

        if scale >= 1 {
            return image
        }

        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var manager: PhotoPickerManager

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            defer {
                picker.dismiss(animated: true)
                parent.presentationMode.wrappedValue.dismiss()
            }

            guard let image = info[.originalImage] as? UIImage else { return }
            let normalized = parent.manager.normalizeImage(image)
            parent.manager.selectedImage = normalized
            parent.manager.onImagePicked?(normalized)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var manager: PhotoPickerManager

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            defer {
                picker.dismiss(animated: true)
                parent.presentationMode.wrappedValue.dismiss()
            }

            guard let image = info[.originalImage] as? UIImage else { return }
            let normalized = parent.manager.normalizeImage(image)
            parent.manager.selectedImage = normalized
            parent.manager.onImagePicked?(normalized)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
