//
//  AudioFileDatabaseProtocol.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

protocol AudioFileDatabaseProtocol {
    func saveAudioFile(_ audioFile: SDAudioFile) async throws
    func getAllAudioFiles() async throws -> [SDAudioFile]
    func searchAudioFiles(_ searchText: String) async throws -> [SDAudioFile]
    func setFavorite(_ audioFileUUID: String) async throws
    func updateLastPosition(_ audioFileUUID: String, lastPosition: Double) async throws
    func getAudioStatus(_ audioFileUUID: String) async throws -> SDAudioFile?
    func deleteAudio(_ audioFileUUID: String) async throws
}
