//
//  EditAudioInfoViewBuilderMock.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//  
//

import Foundation

final class EditAudioInfoViewBuilderMock: EditAudioInfoViewBuilderProtocol {
	func build(fileURL: URL, useCase: AudioFileUseCaseProtocol) -> EditAudioInfoView {
        let utils: UtilsProtocol = Utils()
        let viewModel = EditAudioInfoViewModel(fileURL: fileURL, useCase: useCase, utils: utils)
        let view = EditAudioInfoView(viewModel: viewModel)
		return view
	}
}
