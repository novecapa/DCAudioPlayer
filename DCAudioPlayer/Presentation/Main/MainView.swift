//
//  MainView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

struct MainView: View {

    @State private var selectedTab = 0

    @State var presentPlayer: Bool = false
    @State private var audioPlayer: AudioPlayerManager
    @State private var viewModel: MainViewModel
    init(audioPlayer: AudioPlayerManager = AudioPlayerManager(),
         viewModel: MainViewModel) {
        self.audioPlayer = audioPlayer
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                AudioListViewBuilder().build()
                    .tabItem {
                        Image(systemName: "airpods.max")
                        Text("Audios".localized())
                    }
                    .tag(0)
            }
            .environment(audioPlayer)
            if audioPlayer.isPlaying && selectedTab != 1 {
                VStack {
                    Spacer()
                    AudioPlayerMiniView(audioPlayer: audioPlayer)
                        .background(.white)
                        .onTapGesture {
                            presentPlayer.toggle()
                        }
                }
                .padding(.bottom, 44)
            }
        }
        .sheet(isPresented: $viewModel.showAudioDetails,
               onDismiss: {
            print("onDismiss")
        }, content: {
            if let url = viewModel.filePath {
                EditAudioInfoViewBuilder().build(fileURL: url,
                                                 useCase: viewModel.useCase)
            }
        })
        .fullScreenCover(isPresented: $presentPlayer) {
            AudioPlayerViewBuilder().build(audioPlayer)
        }
    }
}

#Preview {
    MainViewBuilderMock().build()
}
