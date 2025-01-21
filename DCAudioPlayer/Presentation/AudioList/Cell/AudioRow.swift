//
//  AudioRow.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 20/1/25.
//

import SwiftUI

struct AudioRow: View {

    private let audio: AudioFileEntity
    private let selectedAudio: (AudioFileEntity) -> Void
    init(audio: AudioFileEntity,
         selectedAudio: @escaping (AudioFileEntity) -> Void) {
        self.audio = audio
        self.selectedAudio = selectedAudio
    }

    var body: some View {
        HStack(spacing: 0) {
            AsyncImageLoader(url: audio.authorImageURL,
                             placeHolder: audio.authorPlaceholder)
            .clipShape(Circle())
            .frame(width: 40, height: 40)
            .padding(.leading, 12)

            VStack(alignment: .leading) {
                Text(audio.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 12)
                    .padding(.bottom, 6)
                    .foregroundStyle(.black)
                Text(audio.author)
                    .font(.subheadline)
                    .lineLimit(2)
                    .padding(.bottom, 8)
                    .foregroundStyle(.black)
            }
            .padding(.leading, 12)
            Spacer()
            Text(audio.duration.toTimming)
                .font(.subheadline)
                .lineLimit(2)
                .padding(.horizontal, 12)
                .foregroundStyle(.black)
        }
        .frame(minHeight: 60)
        .background(.gray.opacity(0.4))
        .cornerRadius(6)
        .padding(.horizontal, 12)
        .onTapGesture {
            selectedAudio(audio)
        }
    }
}

#Preview {
    AudioRow(audio: .mock) { _ in }
}
