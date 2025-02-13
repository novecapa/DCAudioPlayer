//
//  AudioListView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 19/1/25.
//  
//

import SwiftUI

struct AudioListView: View {

    private enum Constants {
        static let placeholderIcon: String = "airpods.max"
        static let placeholderFrame: CGFloat = 100
    }

    @Environment(AudioPlayerManager.self) var audioPlayer: AudioPlayerManager
    @State var viewModel: AudioListViewModel

    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText,
                          placeHolder: "Buscar por título, autor o descripción".localized())
            if viewModel.filteredAudios.isEmpty {
                Spacer()
                VStack {
                    Image(systemName: Constants.placeholderIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.placeholderFrame,
                               height: Constants.placeholderFrame)
                    Text("Aún no tienes ningún archivo 🫠".localized())
                        .font(.headline)
                        .foregroundStyle(.black)
                        .padding(.top, .paddingM)
                }
                Spacer()
            } else {
                ScrollView {
                    ForEach(viewModel.audioList, id: \.uuid) { audio in
                        AudioRow(audio: audio) { file in
                            viewModel.selectedAudio = file
                            viewModel.showPlayer.toggle()
                        }
                        .lazySwipeActions {
                            SwipeAction(tint: .red,
                                        icon: .trash) {
                                viewModel.deleteAlert(audio)
                            }
                            SwipeAction(tint: .green,
                                        icon: .airpodsMax) {
                                viewModel.editAudio(audio)
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.getAudioList()
                }
                .scrollDismissesKeyboard(.interactively)
                .padding(.top, .paddingL)
            }
        }
        .onAppear {
            viewModel.getAudioList()
        }
        .alert(isPresented: $viewModel.showAlert,
               content: {
            viewModel.deleteAlert
        })
        .sheet(isPresented: $viewModel.showAudioDetails, onDismiss: {
            viewModel.audioToUpdate = nil
            viewModel.getAudioList()
        }, content: {
            if let url = viewModel.fileURL {
                EditAudioInfoViewBuilder().build(fileURL: url,
                                                 useCase: viewModel.useCase,
                                                 audio: viewModel.audioToUpdate)
            }
        })
        .fullScreenCover(
            isPresented: $viewModel.showPlayer,
            content: {
                if let selectedAudio = viewModel.selectedAudio {
                    AudioPlayerViewBuilder()
                        .build(
                            audioPlayer,
                            audioUuid: selectedAudio.uuid
                        )
            }
        })
    }
}

#Preview {
    let audioPlayer = AudioPlayerManager()
    AudioListViewBuilderMock().build()
        .environment(audioPlayer)
}
