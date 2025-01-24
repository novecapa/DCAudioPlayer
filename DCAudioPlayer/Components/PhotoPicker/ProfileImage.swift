//
//  ProfileImage.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 24/1/25.
//

import PhotosUI
import SwiftUI

// MARK: - ImageState
enum ImageState {
    case empty
    case success(Image)
    case failure(Error)
}

// MARK: - ImageStyle
enum ImageStyle {
    case square
    case circular
}

// MARK: - TransferableImage
struct TransferableImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw NSError(domain: "Invalid Image Data", code: -1, userInfo: nil)
            }
            return TransferableImage(image: uiImage)
        }
    }
}

// MARK: - SelectableImageView
struct SelectableImageView: View {
    let imageState: ImageState
    let imageStyle: ImageStyle

    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
                .frame(minWidth: 40, minHeight: 40)
        case .empty:
            let image = Image(systemName: imageStyle == .circular ? .userCircle : .airpodsMax)
            if imageStyle == .circular {
                image
                .resizable()
                .frame(maxWidth: 40, maxHeight: 40)
                .foregroundColor(.black)
            } else {
                image
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(100)
                .foregroundColor(.black)
            }
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .frame(minWidth: 40, minHeight: 40)
                .foregroundColor(.white)
        }
    }
}

// MARK: - SelectableImage
struct SelectableImage: View {
    let imageState: ImageState
    let imageStyle: ImageStyle

    var body: some View {
        let image = SelectableImageView(imageState: imageState, imageStyle: imageStyle)
        if imageStyle == .circular {
            image
                .scaledToFill()
                .clipShape(Circle())
                .background {
                    Circle().fill(
                        LinearGradient(
                            colors: [.white],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .shadow(radius: 4)
        } else {
            image
                .aspectRatio(1, contentMode: .fit)
                .shadow(radius: 4)
        }
    }
}

// MARK: - EditableImage
struct EditableImage: View {

    @State private var imageState: ImageState = .empty {
        didSet {
            switch imageState {
            case .success(let image):
                return selectedImage(image)
            default:
                break
            }
        }
    }
    @State private var imageSelection: PhotosPickerItem?
    let imageStyle: ImageStyle
    let selectedImage: (Image) -> Void

    var body: some View {
        SelectableImage(imageState: imageState,
                        imageStyle: imageStyle)
        .overlay(alignment: .bottomTrailing) {
            PhotosPicker(
                selection: $imageSelection,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Image(systemName: "pencil.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .foregroundColor(.pink)
                    .padding(imageStyle == .circular ? 0 : 2)
            }
            .buttonStyle(.borderless)
        }
        .onChange(of: imageSelection) { newSelection in
            if let newSelection {
                loadImage(from: newSelection)
            } else {
                imageState = .empty
            }
        }
    }

    // MARK: -
    private func loadImage(from imageSelection: PhotosPickerItem) {
        imageSelection.loadTransferable(type: TransferableImage.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(Image(uiImage: profileImage.image))
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

#Preview {
    EditableImage(imageStyle: .square) { image in
        print("image: \(image)")
    }
}
