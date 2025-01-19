//
//  AudioListViewBuilderMock.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 19/1/25.
//  
//

import Foundation

final class AudioListViewBuilderMock: AudioListViewBuilderProtocol {
	func build() -> AudioListView {
        let inMemoryContainer = SwiftDataContainer(isStoredInMemoryOnly: true)
        let database = AudioFileDatabase(databaseManager: inMemoryContainer)
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        let viewModel = AudioListViewModel(useCase: useCase)
        let view = AudioListView(viewModel: viewModel)
        return view
	}
}
