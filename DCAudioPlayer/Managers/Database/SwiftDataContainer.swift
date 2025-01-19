//
//  SwiftDataContainer.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation
import SwiftData

final class SwiftDataContainer: SwiftDataContainerProtocol {

    let container: ModelContainer
    init(isStoredInMemoryOnly: Bool) {
        do {
            self.container = try ModelContainer(
                for: SDAudioFile.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
            )
        } catch {
            fatalError("Failed to create model container: \(error.localizedDescription)")
        }
    }
}
