//
//  AudioPlayerView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

struct AudioPlayerView: View {

    enum Constants {
        static let iconSize: CGFloat = 24
        static let avatarSize: CGFloat = 60
        static let customHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 8
    }

    @Environment(\.dismiss) var dismiss

    private var viewModel: AudioPlayerViewModel
    init(viewModel: AudioPlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: .arrowDown)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.iconSize,
                                   height: Constants.iconSize)
                            .tint(.pink)
                            .padding(.leading, .paddingM)
                    }
                    Spacer()
                    Button {
                        viewModel.setFavorite()
                    } label: {
                        viewModel.imageFavorite
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.iconSize,
                                   height: Constants.iconSize)
                            .tint(.pink)
                            .padding(.trailing, .paddingM)
                    }
                }
                .frame(height: Constants.customHeight)

                ScrollView(showsIndicators: false) {
                    if let image = viewModel.coverAudio {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: geometry.size.width)
                            .background(.gray.opacity(0.4))
                            .clipped()
                            .cornerRadius(Constants.cornerRadius)
                            .padding(.top, .paddingM)
                    } else {
                        Image(systemName: .airpodsMax)
                            .resizable()
                            .padding(.custom(80))
                            .frame(height: geometry.size.width)
                            .background(.gray.opacity(0.4))
                            .foregroundColor(.pink)
                            .clipped()
                            .cornerRadius(Constants.cornerRadius)
                            .padding(.top, .paddingM)
                    }

                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .font(.title)
                            .lineLimit(2)
                            .padding(.top, .paddingL)
                        HStack {
                            if let image = viewModel.authorAvatar {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: Constants.avatarSize,
                                           height: Constants.avatarSize)
                                    .clipped()
                            } else {
                                Image(systemName: .userCircle(true))
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: Constants.avatarSize,
                                           height: Constants.avatarSize)
                            }
                            Text(viewModel.author)
                                .font(.headline)
                                .lineLimit(2)
                        }
                        .padding(.top, .paddingM)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Button {
                            viewModel.backward()
                        } label: {
                            Image(systemName: .backward(.secondsBackward))
                                .font(.largeTitle)
                                .foregroundStyle(.pink)
                        }
                        Spacer()
                        Button {
                            viewModel.playPause()
                        } label: {
                            viewModel.imagePlayPause
                                .font(.largeTitle)
                                .foregroundStyle(.pink)
                        }
                        Spacer()
                        Button {
                            viewModel.forward()
                        } label: {
                            Image(systemName: .forward(.secondsForward))
                                .font(.largeTitle)
                                .foregroundStyle(.pink)
                        }
                    }
                    .padding(.top, .paddingXL)

                    VStack {
                        TimeSlider(value: Binding(
                            get: { viewModel.currentPosition },
                            set: { value in viewModel.currentPosition = value }),
                                   minimumValue: 0,
                                   maximumValue: viewModel.duration,
                                   canUpdateTime: true) { position in
                            viewModel.seekTo(position)
                        }
                        HStack {
                            Text(viewModel.timerInit)
                            Spacer()
                            Text(viewModel.countDownTime)
                        }
                    }.padding(.top, .paddingL)

                    VStack(alignment: .leading) {
                        Text(.init(viewModel.description))
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top, .paddingXL)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, .paddingL)
            .onAppear {
                viewModel.loadAudio()
            }
        }
    }
}
#Preview {
    let persistentContainer = SwiftDataContainer(isStoredInMemoryOnly: true)
    let database = AudioFileDatabase(databaseManager: persistentContainer)
    let repository = AudioFilesRepository(audioFilesDatabse: database)
    let useCase = AudioFileUseCase(repository: repository)
    AudioPlayerView(viewModel: AudioPlayerViewModel(useCase: useCase,
                                                    audioPlayer: AudioPlayerManager()))
}
