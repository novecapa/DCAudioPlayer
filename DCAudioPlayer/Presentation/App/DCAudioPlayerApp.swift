//
//  DCAudioPlayerApp.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import SwiftUI

@main
struct DCAudioPlayerApp: App {

    init() {
        let utils: UtilsProtocol = Utils()
        print("Documents path: \(utils.getDocumentsDirectory.path)")
        utils.createDirectory(directoryName: Utils.Constants.audioFolder)
    }

    var body: some Scene {
        WindowGroup {
            MainViewBuilder().build()
                .onOpenURL { url in
                    if url.pathExtension.lowercased() == .mp3Extension {
                        NotificationCenter.default
                            .post(name: Notification.Name(.didReceiveMP3File),
                                  object: url)
                    }
                }
        }
    }
}
