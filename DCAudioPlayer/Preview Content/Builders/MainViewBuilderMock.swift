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
        // let useCase = MainUseCaseMock()
		let viewModel = MainViewModel()
        let view = MainView(viewModel: viewModel)
		return view
	}
}
