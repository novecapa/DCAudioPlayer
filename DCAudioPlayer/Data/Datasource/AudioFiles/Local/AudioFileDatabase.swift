//
//  AudioFileDatabase.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation
import SwiftData

final class AudioFileDatabase: AudioFileDatabaseProtocol {

    private let databaseManager: SwiftDataContainerProtocol
    init(databaseManager: SwiftDataContainerProtocol) {
        self.databaseManager = databaseManager
    }

    private var currentMillis: Double {
        (Date().timeIntervalSince1970 * 1000).rounded()
    }

    @MainActor
    func saveAudioFile(_ audioFile: SDAudioFile) async throws {
        databaseManager.container.mainContext.insert(audioFile)
        try databaseManager.container.mainContext.save()
    }

    @MainActor
    func getAllAudioFiles() async throws -> [SDAudioFile] {
        let fetchDescription = FetchDescriptor<SDAudioFile>(
            predicate: nil,
            sortBy: [SortDescriptor<SDAudioFile>(\.dateCreated, order: .reverse)]
        )
        return try databaseManager.container.mainContext.fetch(fetchDescription)
    }

    @MainActor
    func searchAudioFiles(_ searchText: String) async throws -> [SDAudioFile] {
        let fetchDescriptor = FetchDescriptor<SDAudioFile>(
            predicate: #Predicate {
                $0.title.localizedStandardContains(searchText) ||
                $0.author.localizedStandardContains(searchText) ||
                $0.desc.localizedStandardContains(searchText) ||
                $0.fileName.localizedStandardContains(searchText)
            },
            sortBy: [SortDescriptor<SDAudioFile>(\.title)]
        )
        return try databaseManager.container.mainContext.fetch(fetchDescriptor)
    }

    @MainActor
    func setFavorite(_ audioFileUUID: String) async throws {
        let fetchDescriptor = FetchDescriptor<SDAudioFile>(
            predicate: #Predicate { $0.uuid == audioFileUUID },
            sortBy: [SortDescriptor<SDAudioFile>(\.uuid)]
        )
        let results = try databaseManager.container.mainContext.fetch(fetchDescriptor)
        guard let audioFile = results.first else {
            throw SwiftDataError.errorSearch("Error guardando como favorito".localized())
        }
        audioFile.isFavorite.toggle()
        audioFile.favoriteAtDate = currentMillis
        audioFile.dateUpdated = currentMillis
        try databaseManager.container.mainContext.save()
    }

    @MainActor
    func updateLastPosition(_ audioFileUUID: String, lastPosition: Double) async throws {
        let fetchDescriptor = FetchDescriptor<SDAudioFile>(
            predicate: #Predicate { $0.uuid == audioFileUUID },
            sortBy: [SortDescriptor<SDAudioFile>(\.uuid)]
        )
        let results = try databaseManager.container.mainContext.fetch(fetchDescriptor)
        guard let audioFile = results.first else {
            throw SwiftDataError.errorSearch("Error en la búsqueda".localized())
        }
        audioFile.lastPositionAtSecond = lastPosition
        audioFile.lastPlayingAtDate = currentMillis
        audioFile.dateUpdated = currentMillis
        try databaseManager.container.mainContext.save()
    }

    @MainActor
    func getAudioStatus(_ audioFileUUID: String) async throws -> SDAudioFile? {
        let fetchDescriptor = FetchDescriptor<SDAudioFile>(
            predicate: #Predicate { $0.uuid == audioFileUUID },
            sortBy: [SortDescriptor<SDAudioFile>(\.uuid)]
        )
        return try databaseManager.container.mainContext.fetch(fetchDescriptor).first
    }

    @MainActor
    func deleteAudio(_ audioFileUUID: String) async throws {
        let fetchDescriptor = FetchDescriptor<SDAudioFile>(
            predicate: #Predicate { $0.uuid == audioFileUUID },
            sortBy: [SortDescriptor<SDAudioFile>(\.uuid)]
        )
        guard let file = try databaseManager.container.mainContext.fetch(fetchDescriptor).first else {
            throw SwiftDataError.errorSearch("Error eliminando el archivo".localized())
        }
        databaseManager.container.mainContext.delete(file)
    }
}
