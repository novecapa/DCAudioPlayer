//
//  MainViewBuilderMock.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import Foundation

final class MainViewBuilderMock: MainViewBuilderProtocol {
	func build() -> MainView {
        let persistentContainer = SwiftDataContainer(isStoredInMemoryOnly: true)
        let database = AudioFileDatabase(databaseManager: persistentContainer)
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        let viewModel = MainViewModel(useCase: useCase)
        let view = MainView(viewModel: viewModel)
		return view
	}
}
