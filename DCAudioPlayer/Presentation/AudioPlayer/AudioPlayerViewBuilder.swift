//
//  AudioPlayerViewBuilder.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import Foundation

protocol AudioPlayerViewBuilderProtocol {
	func build() -> AudioPlayerView
}

final class AudioPlayerViewBuilder: AudioPlayerViewBuilderProtocol {
	func build() -> AudioPlayerView {
        let viewModel = AudioPlayerViewModel()
        let view = AudioPlayerView(viewModel: viewModel)
		return view
	}
}
