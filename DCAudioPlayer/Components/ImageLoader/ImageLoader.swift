//
//  ImageLoader.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 20/1/25.
//

import SwiftUI

@Observable
final class ImageLoader {

    private enum Constants {
        static let imageCacheFolder: String = "ImageCache"
    }

    var image: UIImage?
    private var imageURL: URL?

    private let fileManager = FileManager.default
    private let cacheDirectory: URL? = {
        FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(Constants.imageCacheFolder)
    }()

    init() {
        self.createCacheDirectoryIfNeeded()
    }

    func loadImage(with url: URL) {
        imageURL = url
        if let cachedImage = loadImageFromDisk(url: url) {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  self.imageURL == url,
                  let downloadedImage = UIImage(data: data) else {
                return
            }
            self.saveImageToDisk(image: downloadedImage, url: url)
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}
// MARK: Image cache methods
extension ImageLoader {
    private func createCacheDirectoryIfNeeded() {
        guard let cacheDirectory else { return }
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(
                at: cacheDirectory,
                withIntermediateDirectories: true
            )
        }
    }

    private func saveImageToDisk(image: UIImage, url: URL) {
        guard let data = image.pngData(),
              let cacheDirectory else { return }
        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        try? data.write(to: fileURL)
    }

    private func loadImageFromDisk(url: URL) -> UIImage? {
        guard let cacheDirectory else { return nil }
        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}
