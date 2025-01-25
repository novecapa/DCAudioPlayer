//
//  MainViewModel.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

@Observable
final class MainViewModel {

    // MARK: - Public Properties
    var alertMessage: String = "" {
        didSet {
            if !alertMessage.isEmpty {
                showAlert = true
            }
        }
    }
    var showAlert: Bool = false
    var filePath: URL? {
        didSet {
            if filePath != nil {
                showAudioDetails = true
            }
        }
    }
    var showAudioDetails: Bool = false
    let useCase: AudioFileUseCaseProtocol

    // MARK: - Initializer
    init(useCase: AudioFileUseCaseProtocol) {
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
            filePath = fileURL
        }
    }
}
