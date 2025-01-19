//
//  AudioFilesRepositoryProtocol.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

protocol AudioFilesRepositoryProtocol {
    func saveAudioFile(_ audioFile: AudioFileEntity) async throws
    func getAllAudioFiles() async throws -> [AudioFileEntity]
    func searchAudioFiles(_ searchText: String) async throws -> [AudioFileEntity]
    func setFavorite(_ audioFileUUID: String) async throws
    func updateLastPosition(_ audioFileUUID: String, lastPosition: Double) async throws
    func getAudioStatus(_ audioFileUUID: String) async throws -> AudioFileEntity?
    func deleteAudio(_ audioFileUUID: String) async throws
}
