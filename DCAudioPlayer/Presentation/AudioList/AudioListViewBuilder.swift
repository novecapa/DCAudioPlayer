//
//  AudioListViewBuilder.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 19/1/25.
//  
//

import Foundation

protocol AudioListViewBuilderProtocol {
	func build() -> AudioListView
}

final class AudioListViewBuilder: AudioListViewBuilderProtocol {
	func build() -> AudioListView {
        let persistentContainer = SwiftDataContainer(isStoredInMemoryOnly: false)
        let database = AudioFileDatabase(databaseManager: persistentContainer)
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        let viewModel = AudioListViewModel(useCase: useCase)
        let view = AudioListView(viewModel: viewModel)
		return view
	}
}
