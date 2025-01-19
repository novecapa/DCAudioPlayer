//
//  AudioFileUseCase.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation

final class AudioFileUseCase: AudioFileUseCaseProtocol {

    private let repository: AudioFilesRepositoryProtocol
    init(repository: AudioFilesRepositoryProtocol) {
        self.repository = repository
    }

    func saveAudioFile(_ audioFile: AudioFileEntity) async throws {
        try await repository.saveAudioFile(audioFile)
    }

    func getAllAudioFiles() async throws -> [AudioFileEntity] {
        try await repository.getAllAudioFiles()
    }

    func searchAudioFiles(_ searchText: String) async throws -> [AudioFileEntity] {
        try await repository.searchAudioFiles(searchText)
    }

    func setFavorite(_ audioFileUUID: String) async throws {
        try await repository.setFavorite(audioFileUUID)
    }

    func updateLastPosition(_ audioFileUUID: String, lastPosition: Double) async throws {
        try await repository.updateLastPosition(audioFileUUID, lastPosition: lastPosition)
    }

    func getAudioStatus(_ audioFileUUID: String) async throws -> AudioFileEntity? {
        try await repository.getAudioStatus(audioFileUUID)
    }

    func deleteAudio(_ audioFileUUID: String) async throws {
        try await repository.deleteAudio(audioFileUUID)
    }
}
