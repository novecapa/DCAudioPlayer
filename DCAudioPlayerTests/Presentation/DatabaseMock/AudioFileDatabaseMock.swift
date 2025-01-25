//
//  AudioFileDatabaseMock.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 25/1/25.
//

@testable import DCAudioPlayer

final class AudioFileDatabaseMock: AudioFileDatabaseProtocol {

    private let audioFilesMock: [SDAudioFile]
    init(audioFilesMock: [DCAudioPlayer.SDAudioFile]) {
        self.audioFilesMock = audioFilesMock
    }

    func saveAudioFile(_ audioFile: SDAudioFile) async throws {}

    func getAllAudioFiles() async throws -> [SDAudioFile] {
        audioFilesMock
    }

    func searchAudioFiles(_ searchText: String) async throws -> [SDAudioFile] {
        audioFilesMock
    }

    func setFavorite(_ audioFileUUID: String) async throws {}

    func updateLastPosition(_ audioFileUUID: String, lastPosition: Double) async throws {}

    func getAudioStatus(_ audioFileUUID: String) async throws -> SDAudioFile? {
        audioFilesMock.first
    }

    func deleteAudio(_ audioFileUUID: String) async throws {}
}
