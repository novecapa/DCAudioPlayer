//
//  AudioListView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 19/1/25.
//  
//

import SwiftUI

struct AudioListView: View {

    @State var viewModel: AudioListViewModel

    var body: some View {
        VStack {
            Button(action: {
                viewModel.addNewItem()
            }, label: {
                Text("AudioListView")
            })
            ScrollView {
                ForEach(viewModel.audioList, id: \.uuid) { item in
                    Text("Item: \(item.uuid)")
                        .foregroundStyle(.pink)
                }
            }
        }
        .onAppear {
            viewModel.getAudioList()
        }
    }
}

#Preview {
    AudioListViewBuilderMock().build()
}
