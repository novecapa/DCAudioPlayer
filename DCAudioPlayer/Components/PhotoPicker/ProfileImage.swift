//
//  ProfileImage.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 24/1/25.
//

import PhotosUI
import SwiftUI

// MARK: - 
enum ImageState {
    case empty
    case loading
    case success(Image)
    case failure(Error)
}

// MARK: -
struct ProfileImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw NSError(domain: "Invalid Image Data", code: -1, userInfo: nil)
            }
            return ProfileImage(image: uiImage)
        }
    }
}

// MARK: -
struct ProfileImageView: View {
    let imageState: ImageState

    var body: some View {
        switch imageState {
        case .success(let image):
            image
                .resizable()
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

// MARK: -
struct CircularProfileImage: View {
    let imageState: ImageState

    var body: some View {
        ProfileImageView(imageState: imageState)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 100, height: 100)
            .background {
                Circle().fill(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .shadow(radius: 4)
    }
}

// MARK: -
struct EditableCircularProfileImage: View {

    @State private var imageState: ImageState = .empty
    @State private var imageSelection: PhotosPickerItem?

    var body: some View {
        CircularProfileImage(imageState: imageState)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(
                    selection: $imageSelection,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
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
        imageState = .loading

        imageSelection.loadTransferable(type: ProfileImage.self) { result in
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
    EditableCircularProfileImage()
}
