//
//  AudioListViewModel.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 19/1/25.
//  
//

import SwiftUI

@Observable
final class AudioListViewModel {

    // MARK: - Public Properties
    var showPlayer: Bool = false
    var searchText: String = ""
    var showAlert: Bool = false
    var audioToUpdate: AudioFileEntity?
    var showAudioDetails: Bool = false

    var audioList: [AudioFileEntity] = []
    var selectedAudio: AudioFileEntity?

    var alertMessage: String = "" {
        didSet {
            guard !alertMessage.isEmpty else {
                return
            }
            showAlert = true
        }
    }

    let useCase: AudioFileUseCaseProtocol

    // MARK: - Private Properties
    private let utils: UtilsProtocol

    // MARK: - Initializer
    init(useCase: AudioFileUseCaseProtocol,
         utils: UtilsProtocol = Utils()) {
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

    private func deleteAudio(_ audio: AudioFileEntity) {
        Task {
            do {
                audioList.removeAll { $0.uuid == audio.uuid }
                try await useCase.deleteAudio(audio.uuid)
            } catch {
                handleError(error)
            }
        }
    }
}
extension AudioListViewModel {
    func getAudioList() {
        Task { @MainActor in
            do {
                self.audioList = try await useCase.getAllAudioFiles()
            } catch {
                handleError(error)
            }
        }
    }

    // Search
    var filteredAudios: [AudioFileEntity] {
        if searchText.isEmpty && searchText.count < 3 {
            return audioList
        } else {
            return audioList.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.author.lowercased().contains(searchText.lowercased()) ||
                $0.desc.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Delete action
    func deleteAlert(_ audio: AudioFileEntity) {
        audioToUpdate = audio
        showAlert = true
    }

    var deleteAlert: Alert {
        Alert(
            title: Text("Atención".localized()),
            message: Text("¿Estás seguro? El archivo se eliminará para siempre".localized()),
            primaryButton: .destructive(Text("Si, eliminar".localized()), action: { [weak self] in
                guard let self, let audio = self.audioToUpdate else { return }
                withAnimation {
                    self.deleteAudio(audio)
                }
                self.audioToUpdate = nil
                showAlert = false
            }),
            secondaryButton: .default(Text("No, Cancelar".localized()))
        )
    }

    // Edit action
    var fileURL: URL? {
        guard let fileName = audioToUpdate?.fileName else { return nil }
        return utils.getFilePath(fileName)
    }

    func editAudio(_ audio: AudioFileEntity) {
        audioToUpdate = audio
        showAudioDetails = true
    }
}
