//
//  AudioPlayerViewBuilder.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import Foundation

protocol AudioPlayerViewBuilderProtocol {
    func build(_ manager: AudioPlayerManager, audioUuid: String) -> AudioPlayerView
}

final class AudioPlayerViewBuilder: AudioPlayerViewBuilderProtocol {
	func build(_ manager: AudioPlayerManager, audioUuid: String = "") -> AudioPlayerView {
        let persistentContainer = SwiftDataContainer(isStoredInMemoryOnly: false)
        let database = AudioFileDatabase(databaseManager: persistentContainer)
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        let viewModel = AudioPlayerViewModel(useCase: useCase, audioPlayer: manager, audioUuid: audioUuid)
        let view = AudioPlayerView(viewModel: viewModel)
		return view
	}
}
