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

    var alertMessage: String = "" {
        didSet {
            if !alertMessage.isEmpty {
                showAlert = true
            }
        }
    }
    var showAlert: Bool = false

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
            let fileName = fileURL.lastPathComponent
            let destinationURL = utils.getMP3Path(fileName)

            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }

            try fileManager.moveItem(at: fileURL, to: destinationURL)

            // Save item
            addNewItem(destinationURL)
        } catch {
            print("Error al copiar el archivo: \(error)")
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
        let audioPlayer = try? AVAudioPlayer(contentsOf: fileURL)
        return audioPlayer?.duration ?? 0
    }

    var audioName: String {
        String(fileURL.lastPathComponent.split(separator: ".").first ?? "")
    }

    var previewAudioData: AudioFileEntity {
        AudioFileEntity(
            uuid: UUID().uuidString,
            title: "",
            desc: "",
            author: "",
            user: "",
            authorAvatar: "",
            publishDate: "",
            duration: audioDuration,
            cover: "",
            filePath: "",
            fileName: audioName,
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
        let fileName = String(fileURL.lastPathComponent.split(separator: ".").first ?? "")
        return AudioFileEntity(
            uuid: UUID().uuidString,
            title: "",
            desc: "",
            author: "",
            user: "",
            authorAvatar: "",
            publishDate: "",
            duration: audioDuration,
            cover: "",
            filePath: destinationURL.path,
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
}
