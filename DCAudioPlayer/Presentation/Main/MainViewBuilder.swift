//
//  MainViewBuilder.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import Foundation

protocol MainViewBuilderProtocol {
	func build() -> MainView
}

final class MainViewBuilder: MainViewBuilderProtocol {
	func build() -> MainView {
        // let useCase = MainUseCase()
		let viewModel = MainViewModel()
        let view = MainView(viewModel: viewModel)
		return view
	}
}
