//
//  MainView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//  
//

import SwiftUI

struct MainView: View {

    @State var viewModel: MainViewModel

    var body: some View {
        ZStack {
            TabView {
                AudioListViewBuilder().build()
                    .tabItem {
                        Image(systemName: "airpods.max")
                        Text("Audios".localized())
                    }
                    .tag(0)
            }
        }
    }
}

#Preview {
    MainViewBuilderMock().build()
}
