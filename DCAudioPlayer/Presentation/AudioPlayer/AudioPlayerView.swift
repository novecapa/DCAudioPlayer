//
//  AudioPlayerView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

struct AudioPlayerView: View {

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
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .tint(.pink)
                            .padding(.leading, 8)
                    }
                    Spacer()
                    Button {
                        viewModel.setFavorite()
                    } label: {
                        viewModel.imageFavorite
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .tint(.pink)
                            .padding(.trailing, 8)
                    }
                }
                .frame(height: 50)

                ScrollView(showsIndicators: false) {
                    if let image = viewModel.coverAudio {
                        Image(uiImage: image)
                            .scaledToFit()
                            .frame(height: geometry.size.width)
                            .background(.gray.opacity(0.4))
                            .clipped()
                            .cornerRadius(8)
                            .padding(.top, 8)
                    } else {
                        Image(systemName: "airpods.max")
                            .resizable()
                            .padding(80)
                            .frame(height: geometry.size.width)
                            .background(.gray.opacity(0.4))
                            .foregroundColor(.pink)
                            .clipped()
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .font(.title)
                            .lineLimit(2)
                            .padding(.top, 16)
                        HStack {
                            if let image = viewModel.authorAvatar {
                                Image(uiImage: image)
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 40, height: 40)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 40, height: 40)
                            }
                            Text(viewModel.author)
                                .font(.headline)
                                .lineLimit(2)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Button {
                            viewModel.backward()
                        } label: {
                            Image(systemName: "gobackward.15")
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
                            Image(systemName: "goforward.15")
                                .font(.largeTitle)
                                .foregroundStyle(.pink)
                        }
                    }
                    .padding(.top, 24)

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
                    }.padding(.top, 16)

                    VStack(alignment: .leading) {
                        Text(.init(viewModel.description))
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 16)
            .onAppear {
                viewModel.loadAudio()
            }
        }
    }
}
