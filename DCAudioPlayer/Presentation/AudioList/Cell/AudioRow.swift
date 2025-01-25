//
//  AudioRow.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 20/1/25.
//

import SwiftUI

struct AudioRow: View {

    private enum Constants {
        static let avatarSize: CGFloat = 60
    }

    private let audio: AudioFileEntity
    private let selectedAudio: (AudioFileEntity) -> Void
    private let utils: UtilsProtocol
    init(audio: AudioFileEntity,
         utils: UtilsProtocol = Utils(),
         selectedAudio: @escaping (AudioFileEntity) -> Void) {
        self.audio = audio
        self.utils = utils
        self.selectedAudio = selectedAudio
    }

    var body: some View {
        HStack(spacing: 0) {
            let url = utils.getFilePath(audio.authorAvatar)
            if let image = UIImage(contentsOfFile: url.path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: Constants.avatarSize, height: Constants.avatarSize)
                    .padding(.paddingM)
                    .clipped()
            } else {
                Image(systemName: .userCircle(true))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: Constants.avatarSize, height: Constants.avatarSize)
                    .padding(.paddingM)
            }
            VStack(alignment: .leading) {
                Text(audio.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.top, .paddingM)
                    .padding(.bottom, .paddingS)
                    .foregroundStyle(.black)
                Text(audio.author)
                    .font(.subheadline)
                    .lineLimit(2)
                    .padding(.bottom, .paddingS)
                    .foregroundStyle(.black)
            }
            .padding(.leading, .paddingM)
            Spacer()
            Text(audio.duration.toTimming)
                .font(.subheadline)
                .lineLimit(2)
                .padding(.horizontal, .paddingM)
                .foregroundStyle(.black)
        }
        .frame(minHeight: Constants.avatarSize)
        .background(.gray.opacity(0.4))
        .cornerRadius(6)
        .padding(.horizontal, .paddingM)
        .onTapGesture {
            selectedAudio(audio)
        }
    }
}

#Preview {
    AudioRow(audio: .mock) { _ in }
}
