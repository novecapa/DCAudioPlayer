//
//  AudioPlayerViewModel.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

@Observable
final class AudioPlayerViewModel {

    // MARK: - Public Properties
    var audioFile: AudioFileEntity = .empty

    // MARK: - Private Properties
    private let useCase: AudioFileUseCase
    private let audioManager: AudioPlayerManager
    private let audioUuid: String
    private let utils: UtilsProtocol

    // MARK: - Initializer
    init(useCase: AudioFileUseCase,
         audioPlayer: AudioPlayerManager,
         audioUuid: String = "",
         utils: UtilsProtocol = Utils()) {
        self.useCase = useCase
        self.audioManager = audioPlayer
        self.audioUuid = audioUuid
        self.utils = utils
        self.audioManager.delegate = self
    }

    private func handleError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    private func loadLastPosition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self, !self.audioManager.isPlaying else { return }
            Task {
                await self.audioFileStatus()
                await MainActor.run {
                    self.audioManager.seek(to: self.audioFile.lastPositionAtSecond)
                }
            }
        }
    }

    private func saveLastPosition(_ position: Double) {
        Task {
            try? await useCase.updateLastPosition(audioFile.uuid, lastPosition: position)
        }
    }
}
// MARK: Public var
extension AudioPlayerViewModel {
    func audioFileStatus() async {
        guard let result = try? await useCase.getAudioStatus(audioFile.uuid) else {
            return
        }
        audioFile = result
    }

    var imageFavorite: Image {
        Image(systemName: audioFile.isFavorite ? "heart.fill" : "heart")
    }

    var coverAudio: UIImage? {
        let url = utils.getFilePath(audioFile.cover)
        return UIImage(contentsOfFile: url.path)
    }

    var title: String {
        audioFile.title
    }

    var authorAvatar: UIImage? {
        let url = utils.getFilePath(audioFile.authorAvatar)
        return UIImage(contentsOfFile: url.path)
    }

    var author: String {
        audioFile.author
    }

    var currentPosition: Double {
        get {
            audioManager.currentPosition
        }
        set {
            audioManager.currentPosition = newValue
            saveLastPosition(newValue)
        }
    }

    var duration: Double {
        audioManager.duration
    }

    var timerInit: String {
        audioManager.currentTime.toTimming
    }

    var countDownTime: String {
        audioManager.countDownTime
    }

    var description: String {
        audioFile.desc
    }

    var imagePlayPause: Image {
        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
    }
}
// MARK: Public methods
extension AudioPlayerViewModel {
    func setFavorite() {
        Task {
            do {
                try await useCase.setFavorite(audioFile.uuid)
                await audioFileStatus()
            } catch {
                handleError(error)
            }
        }
    }

    func backward() {
        audioManager.backward()
    }

    func forward() {
        audioManager.forward()
    }

    func seekTo(_ position: Double) {
        audioManager.seek(to: position)
        saveLastPosition(position)
    }

    func loadAudio() {
        Task {
            do {
                if audioUuid.isEmpty {
                    audioFile = audioManager.currentTrack
                    return
                }
                guard let res = try await useCase.getAudioStatus(audioUuid) else {
                    return
                }
                self.audioFile = res
                await MainActor.run {
                    self.audioManager.loadAudio(currentTrack: audioFile)
                }
                self.loadLastPosition()
            } catch {
                handleError(error)
            }
        }
    }

    func playPause() {
        if audioManager.isPlaying {
            audioManager.pause()
        } else {
            audioManager.play()
        }
    }
}

// MARK: AudioPlayerManagerProtocol
extension AudioPlayerViewModel: AudioPlayerManagerProtocol {
    func audioStateChanged() {}

    func audioTimeChanged(_ position: Double) {
        saveLastPosition(position)
    }
}
