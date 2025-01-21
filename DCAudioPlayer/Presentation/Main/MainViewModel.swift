//
//  MainViewModel.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import AVFoundation
import SwiftUI

@Observable
final class MainViewModel {

    var alertMessage: String = "" {
        didSet {
            if !alertMessage.isEmpty {
                showAlert = true
            }
        }
    }
    var showAlert: Bool = false

    private let utils: UtilsProtocol
    private let useCase: AudioFileUseCaseProtocol
    init(utils: UtilsProtocol,
         useCase: AudioFileUseCaseProtocol) {
        self.utils = utils
        self.useCase = useCase
        startListenNotifications()
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

    private func startListenNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReceivedMP3File(notification:)),
                                               name: Notification.Name(.didReceiveMP3File),
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(.didReceiveMP3File),
                                                  object: nil)
    }

    @objc func handleReceivedMP3File(notification: Notification) {
        if let fileURL = notification.object as? URL {
            saveFile(fileURL)
        }
    }

    private func saveFile(_ sourceURL: URL) {
        do {
            let fileManager = utils.getFileManager
            let fileName = sourceURL.lastPathComponent
            let destinationURL = utils.getMP3Path(fileName)

            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }

            try fileManager.moveItem(at: sourceURL, to: destinationURL)

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
                // TODO: reload list
            } catch {
                handleError(error)
            }
        }
    }

    func getDuraton(from url: URL) -> TimeInterval {
        let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        return audioPlayer?.duration ?? 0
    }

    func prepareNewItem(_ destinationURL: URL) -> AudioFileEntity {
        let fileName = String(destinationURL.lastPathComponent.split(separator: ".").first ?? "")
        let duration = getDuraton(from: destinationURL)
        return AudioFileEntity(
            uuid: UUID().uuidString,
            title: "title",
            desc: "desc",
            author: "author",
            user: "user",
            authorAvatar: "",
            publishDate: "",
            duration: duration,
            cover: "",
            filePath: destinationURL.path,
            fileName: fileName,
            isFavorite: false,
            favoriteAtDate: 0,
            lastStartDate: 0,
            lastPositionAtSecond: 0,
            lastPlayingAtDate: 0,
            userComments: "userComments",
            rating: 0,
            dateCreated: utils.getCurrentMillis,
            dateUpdated: 0
        )
    }
}
