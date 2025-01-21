//
//  AudioPlayerMiniView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 21/1/25.
//

import SwiftUI

struct AudioPlayerMiniView: View {

    let audioPlayer: AudioPlayerManager
    init(audioPlayer: AudioPlayerManager) {
        self.audioPlayer = audioPlayer
    }

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    audioPlayer.backward()
                } label: {
                    Image(systemName: "gobackward.15")
                        .font(.largeTitle)
                        .foregroundStyle(.pink)
                }
                Spacer()
                Button {
                    playPause()
                } label: {
                    imagePlayPause
                        .font(.largeTitle)
                        .foregroundStyle(.pink)
                }
                Spacer()
                Button {
                    audioPlayer.forward()
                } label: {
                    Image(systemName: "goforward.15")
                        .font(.largeTitle)
                        .foregroundStyle(.pink)
                }
            }
            .padding(.horizontal, 24)
            Text(audioPlayer.currentTrack.title)
                .font(.headline)
                .padding(.top, 8)
                .padding(.horizontal, 24)
            HStack {
                Text(timerInit)
                    .font(.subheadline)
                Spacer()
                Text(countDownTime)
                    .font(.subheadline)
            }
            .padding(.top, 8)
            .padding(.horizontal, 24)
            TimeSlider(value: Binding(
                get: { audioPlayer.currentPosition },
                set: { value in audioPlayer.currentPosition = value }),
                       minimumValue: 0,
                       maximumValue: audioPlayer.duration,
                       canUpdateTime: false) { position in
                audioPlayer.seekTo(position)
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 16)
    }

    private var imagePlayPause: Image {
        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
    }

    private func playPause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    private var timerInit: String {
        audioPlayer.currentTime.toTimming
    }

    private var countDownTime: String {
        audioPlayer.countDownTime
    }
}

#Preview {
    AudioPlayerMiniView(audioPlayer: AudioPlayerManager())
}
