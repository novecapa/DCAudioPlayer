//
//  AudioPlayerView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

struct AudioPlayerView: View {

    @State var viewModel: AudioPlayerViewModel

    var body: some View {
        Text("AudioPlayerView")
    }
}

#Preview {
    AudioPlayerViewBuilderMock().build()
}
