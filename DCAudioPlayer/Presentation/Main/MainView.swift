//
//  MainView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

struct MainView: View {

    enum Constants {
        static let tabBarHeight: CGFloat = 44
    }

    @State private var selectedTab = 0
    @State var isPlayerPresented: Bool = false

    @State private var audioPlayer: AudioPlayerManager
    @State private var viewModel: MainViewModel
    private let audioListView: AudioListView

    // MARK: - Initializer
    init(audioPlayer: AudioPlayerManager = AudioPlayerManager(),
         viewModel: MainViewModel,
         audioListView: AudioListView = AudioListViewBuilder().build()) {
        self.audioPlayer = audioPlayer
        self.viewModel = viewModel
        self.audioListView = audioListView
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                audioListView
                    .tabItem {
                        Image(systemName: .airpodsMax)
                        Text("Audios".localized())
                    }
                    .tag(0)
            }
            .environment(audioPlayer)

            if shouldShowMiniPlayer {
                miniPlayerView
            }
        }
        .sheet(isPresented: $viewModel.showAudioDetails,
               onDismiss: handleDismissDetails) {
            if let url = viewModel.filePath {
                EditAudioInfoViewBuilder().build(fileURL: url,
                                                 useCase: viewModel.useCase,
                                                 audio: nil)
            }
        }
        .fullScreenCover(isPresented: $isPlayerPresented) {
            AudioPlayerViewBuilder().build(audioPlayer)
        }
    }

    // MARK: - Computed Views
    private var shouldShowMiniPlayer: Bool {
        audioPlayer.isPlaying
    }

    private var miniPlayerView: some View {
        VStack {
            Spacer()
            AudioPlayerMiniView(audioPlayer: audioPlayer)
                .background(Color.white)
                .onTapGesture {
                    isPlayerPresented.toggle()
                }
        }
        .padding(.bottom, Constants.tabBarHeight)
    }

    // MARK: - Handlers
    private func handleDismissDetails() {
        audioListView.viewModel.getAudioList()
    }
}

#Preview {
    MainViewBuilderMock().build()
}
