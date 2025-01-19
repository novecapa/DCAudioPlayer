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

    var audioList: [AudioFileEntity] = [] {
        didSet {
            print("audioList: \(audioList.last?.title ?? "---")")
        }
    }
    
    private let useCase: AudioFileUseCaseProtocol
    init(useCase: AudioFileUseCaseProtocol) {
        self.useCase = useCase
    }
}
extension AudioListViewModel {
    func getAudioList() {
        Task { @MainActor in
            do {
                self.audioList = try await useCase.getAllAudioFiles()
                print("audioList count: \(self.audioList.count)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func addNewItem() {
        Task { @MainActor in
            do {
                let item = prepareNewItem()
                try await useCase.saveAudioFile(item)
                self.getAudioList()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func prepareNewItem() -> AudioFileEntity {
        AudioFileEntity(
            uuid: UUID().uuidString,
            title: "title",
            desc: "desc",
            author: "author",
            user: "user",
            authorAvatar: "authorAvatar",
            publishDate: "publishDate",
            duration: 0,
            cover: "cover",
            filePath: "filePath",
            fileName: "fileName",
            isFavorite: false,
            favoriteAtDate: 0,
            lastStartDate: 0,
            lastPositionAtSecond: 0,
            lastPlayingAtDate: 0,
            userComments: "userComments",
            rating: 0,
            dateCreated: (Date().timeIntervalSince1970 * 1000).rounded(),
            dateUpdated: 0
        )
    }
}
