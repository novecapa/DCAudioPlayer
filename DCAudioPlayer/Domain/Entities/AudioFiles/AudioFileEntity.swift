//
//  AudioFileEntity.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation

struct AudioFileEntity {

    let uuid: String
    let title: String
    let desc: String
    let author: String
    let user: String
    let authorAvatar: String
    let publishDate: String
    let duration: Double
    let cover: String

    let filePath: String
    let fileName: String

    let isFavorite: Bool
    let favoriteAtDate: Double

    let lastStartDate: Double
    let lastPositionAtSecond: Double
    let lastPlayingAtDate: Double

    let userComments: String
    let rating: Int

    let dateCreated: Double
    let dateUpdated: Double
}
