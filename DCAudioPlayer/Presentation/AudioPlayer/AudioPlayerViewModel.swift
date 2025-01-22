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

    private let useCase: AudioFileUseCase
    private let audioManager: AudioPlayerManager
    private let audioFile: AudioFileEntity
    init(useCase: AudioFileUseCase,
         audioPlayer: AudioPlayerManager,
         audioFile: AudioFileEntity = .empty) {
        self.useCase = useCase
        self.audioManager = audioPlayer
        self.audioFile = audioFile == .empty ?
        audioPlayer.currentTrack :
        audioFile
        self.audioManager.delegate = self
        loadLastPosition()
    }

    private func handleError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    private var currentTrack: AudioFileEntity {
        audioManager.currentTrack
    }

    private func loadLastPosition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self, !self.audioManager.isPlaying else { return }
            self.audioManager.seekTo(self.lastPosition)
        }
    }

    private func saveLastPosition(_ position: Double) {
        Task {
            try? await useCase.updateLastPosition(currentTrack.uuid, lastPosition: position)
        }
    }
}
// MARK: Public var
extension AudioPlayerViewModel {
    func audioFileStatus() {
        Task {
            do {
                let status = try await useCase.getAudioStatus(currentTrack.uuid)
                print("status: \(status?.title ?? "")")
            } catch {
                handleError(error)
            }
        }
    }

    var imageFavorite: Image {
        let name = audioFile.isFavorite == true ?
        "heart.fill" :
        "heart"
        return Image(systemName: name)
    }

    var coverAudio: UIImage? {
        UIImage(contentsOfFile: currentTrack.cover)
    }

    var title: String {
        currentTrack.title
    }

    var authorAvatar: UIImage? {
        UIImage(contentsOfFile: currentTrack.authorAvatar)
    }

    var author: String {
        currentTrack.author
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
        currentTrack.desc
    }

    var imagePlayPause: Image {
        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
    }

    var lastPosition: Double {
        audioFile.lastPositionAtSecond
    }
}
// MARK: Public methods
extension AudioPlayerViewModel {
    func setFavorite() {
        Task {
            do {
                try await useCase.setFavorite(audioManager.currentTrack.uuid)
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
        audioManager.seekTo(position)
        saveLastPosition(position)
    }

    func loadAudio() {
        audioManager.loadAudio(currentTrack: audioFile)
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
