//
//  AudioFilesRepository.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation

final class AudioFilesRepository: AudioFilesRepositoryProtocol {

    private let audioFilesDatabse: AudioFileDatabaseProtocol
    init(audioFilesDatabse: AudioFileDatabaseProtocol) {
        self.audioFilesDatabse = audioFilesDatabse
    }

    func saveAudioFile(_ audioFile: AudioFileEntity) async throws {
        try await audioFilesDatabse.saveAudioFile(audioFile.toSwiftData)
    }

    func getAllAudioFiles() async throws -> [AudioFileEntity] {
        try await audioFilesDatabse.getAllAudioFiles().map { $0.toEntity }
    }

    func searchAudioFiles(_ searchText: String) async throws -> [AudioFileEntity] {
        try await audioFilesDatabse.searchAudioFiles(searchText).map { $0.toEntity }
    }

    func setFavorite(_ audioFileUUID: String) async throws {
        try await audioFilesDatabse.setFavorite(audioFileUUID)
    }

    func updateLastPosition(_ audioFileUUID: String, lastPosition: Double) async throws {
        try await audioFilesDatabse.updateLastPosition(audioFileUUID, lastPosition: lastPosition)
    }

    func getAudioStatus(_ audioFileUUID: String) async throws -> AudioFileEntity? {
        try await audioFilesDatabse.getAudioStatus(audioFileUUID).map { $0.toEntity }
    }

    func deleteAudio(_ audioFileUUID: String) async throws {
        try await audioFilesDatabse.deleteAudio(audioFileUUID)
    }
}
// MARK: AudioFileEntity
fileprivate extension AudioFileEntity {
    var toSwiftData: SDAudioFile {
        SDAudioFile(
            uuid: self.uuid,
            title: self.title,
            desc: self.desc,
            author: self.author,
            user: self.user,
            authorAvatar: self.authorAvatar,
            publishDate: self.publishDate,
            duration: self.duration,
            cover: self.cover,
            dateCreated: self.dateCreated
        )
    }
}
// MARK: SDAudioFile
fileprivate extension SDAudioFile {
    var toEntity: AudioFileEntity {
        AudioFileEntity(
            uuid: self.uuid,
            title: self.title,
            desc: self.desc,
            author: self.author,
            user: self.user,
            authorAvatar: self.authorAvatar,
            publishDate: self.publishDate,
            duration: self.duration,
            cover: self.cover,
            filePath: self.filePath,
            fileName: self.fileName,
            isFavorite: self.isFavorite,
            favoriteAtDate: self.favoriteAtDate,
            lastStartDate: self.lastStartDate,
            lastPositionAtSecond: self.lastPositionAtSecond,
            lastPlayingAtDate: self.lastPlayingAtDate,
            userComments: self.userComments,
            rating: self.rating,
            dateCreated: self.dateCreated,
            dateUpdated: self.dateUpdated
        )
    }
}
