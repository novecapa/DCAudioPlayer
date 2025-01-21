//
//  AsyncImageLoader.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 20/1/25.
//

import SwiftUI

struct AsyncImageLoader: View {

    private let url: URL?
    @State private var loader: ImageLoader
    private let placeHolder: Image?
    init(url: URL?,
         loader: ImageLoader = ImageLoader(),
         placeHolder: Image? = nil) {
        self.url = url
        self.loader = loader
        self.placeHolder = placeHolder
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity.animation(.easeInOut))
            } else {
                ZStack {
                    if let placeHolder {
                        placeHolder
                    }
                }
                .scaledToFit()
                .background(.gray.opacity(0.2))
            }
        }
        .onAppear {
            guard let url else { return }
            loader.loadImage(with: url)
        }
    }

    var imageLoaded: UIImage {
        loader.image ?? UIImage()
    }
}
