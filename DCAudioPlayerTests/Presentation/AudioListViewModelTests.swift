//
//  AudioListViewModelTests.swift
//  DCAudioPlayerTests
//
//  Created by Josep Cerdá Penadés on 25/1/25.
//

@testable import DCAudioPlayer
import XCTest

final class AudioListViewModelTests: XCTestCase {

    var viewModel: AudioListViewModel!

    override func setUp() {
        super.setUp()
        let database = AudioFileDatabaseMock(audioFilesMock: [])
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        viewModel = AudioListViewModel(useCase: useCase)
    }

    override func tearDown() {
        viewModel = nil
    }

    func test_getAudioList() async {
        // Given -> Mock
        let database = AudioFileDatabaseMock(audioFilesMock: [.mock])
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        viewModel = AudioListViewModel(useCase: useCase)

        // When
        let expectation = XCTestExpectation(description: "Wait for it...")
        Task { @MainActor in
            viewModel.getAudioList()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(viewModel.audioList.count, 1)
    }

    func test_searchAudioList() async {
        // Given -> Mock
        let database = AudioFileDatabaseMock(audioFilesMock: [.mock, .mock])
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        viewModel = AudioListViewModel(useCase: useCase)

        // When
        let expectation = XCTestExpectation(description: "Wait for it...")
        Task { @MainActor in
            viewModel.getAudioList()
            viewModel.searchText = SDAudioFile.mock.title
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(viewModel.filteredAudios.count, 2)
    }

    func test_deleteAudio() async {
        // Given -> Mock
        let database = AudioFileDatabaseMock(audioFilesMock: [.mock])
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        viewModel = AudioListViewModel(useCase: useCase)

        // When
        let expectation = XCTestExpectation(description: "Wait for it...")
        Task { @MainActor in
            viewModel.getAudioList()
            viewModel.deleteAlert(.mock)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(viewModel.audioToUpdate, .mock)
        XCTAssertTrue(viewModel.showAlert)
    }

    func test_editAudio() async {
        // Given -> Mock
        let database = AudioFileDatabaseMock(audioFilesMock: [.mock])
        let repository = AudioFilesRepository(audioFilesDatabse: database)
        let useCase = AudioFileUseCase(repository: repository)
        viewModel = AudioListViewModel(useCase: useCase)

        // When
        let expectation = XCTestExpectation(description: "Wait for it...")
        Task { @MainActor in
            viewModel.getAudioList()
            viewModel.editAudio(.mock)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(viewModel.audioToUpdate, .mock)
        XCTAssertTrue(viewModel.showAudioDetails)
    }
}
