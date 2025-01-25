//
//  EditAudioInfoViewModel.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//  
//

import AVFoundation
import SwiftUI

@Observable
final class EditAudioInfoViewModel {

    // MARK: Public
    var title: String = ""
    var author: String = ""
    var desc: String = ""
    var coverImagePath: String = ""
    var authorImagePath: String = ""

    // MARK: Alert message
    var alertMessage: String = "" {
        didSet {
            if !alertMessage.isEmpty {
                showAlert = true
            }
        }
    }
    var showAlert: Bool = false

    // MARK: Private properties
    private let fileURL: URL
    private let useCase: AudioFileUseCaseProtocol
    private let utils: UtilsProtocol
    init(fileURL: URL,
         useCase: AudioFileUseCaseProtocol,
         utils: UtilsProtocol) {
        self.fileURL = fileURL
        self.useCase = useCase
        self.utils = utils
    }

    private func handleError(_ error: Error) {
        guard let error = error as? SwiftDataError else {
            return
        }
        switch error {
        case .errorSave(let message),
                .errorFetch(let message),
                .errorSearch(let message),
                .errorDelete(let message):
            alertMessage = message
        }
    }

    func saveFile() {
        do {
            let fileManager = utils.getFileManager
            let destinationURL = utils.getFilePath(fileName)
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.moveItem(at: fileURL, to: destinationURL)
            addNewItem(destinationURL)
        } catch {
            handleError(error)
        }
    }

    private func addNewItem(_ destinationURL: URL) {
        Task { @MainActor in
            do {
                let item = prepareNewItem(destinationURL)
                try await useCase.saveAudioFile(item)
            } catch {
                handleError(error)
            }
        }
    }

    var audioDuration: TimeInterval {
        let fileUrl = utils.getFilePath(fileName)
        let audioPlayer = try? AVAudioPlayer(contentsOf: fileUrl)
        return audioPlayer?.duration ?? 0
    }

    var fileName: String {
        String(fileURL.lastPathComponent)
    }

    var previewAudioData: AudioFileEntity {
        AudioFileEntity(
            uuid: "",
            title: self.title,
            desc: self.desc,
            author: self.author,
            user: "",
            authorAvatar: self.authorImagePath,
            publishDate: "",
            duration: audioDuration,
            cover: self.coverImagePath,
            fileName: fileName,
            isFavorite: false,
            favoriteAtDate: 0,
            lastStartDate: 0,
            lastPositionAtSecond: 0,
            lastPlayingAtDate: 0,
            userComments: "",
            rating: 0,
            dateCreated: utils.getCurrentMillis,
            dateUpdated: 0
        )
    }
    func prepareNewItem(_ destinationURL: URL) -> AudioFileEntity {
        AudioFileEntity(
            uuid: UUID().uuidString,
            title: self.title,
            desc: self.desc,
            author: self.author,
            user: "",
            authorAvatar: self.authorImagePath,
            publishDate: "",
            duration: audioDuration,
            cover: self.coverImagePath,
            fileName: fileName,
            isFavorite: false,
            favoriteAtDate: 0,
            lastStartDate: 0,
            lastPositionAtSecond: 0,
            lastPlayingAtDate: 0,
            userComments: "",
            rating: 0,
            dateCreated: utils.getCurrentMillis,
            dateUpdated: 0
        )
    }

    func saveImage(image: UIImage, from type: ImageStyle) {
        guard let imageData = image.pngData() else {
            return
        }
        let imageFileName = fileURL.hashValue.toString + "_" + type.rawValue + ".png"
        let fileURL = utils.getFilePath(imageFileName)
        try? imageData.write(to: fileURL)
        switch type {
        case .circular:
            self.authorImagePath = imageFileName
        case .square:
            self.coverImagePath = imageFileName
        }
    }
}
