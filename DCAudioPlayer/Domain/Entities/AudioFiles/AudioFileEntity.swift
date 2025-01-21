//
//  AudioFileEntity.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import SwiftUI

struct AudioFileEntity: Equatable {

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

    var authorImageURL: URL? {
        URL(string: authorAvatar)
    }

    var authorPlaceholder: Image? {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 40, height: 40) as? Image
    }

    var audioCoverURL: URL? {
        URL(string: cover)
    }
}

// MARK: Mocks
extension AudioFileEntity {
    static let empty: AudioFileEntity = AudioFileEntity(
        uuid: "",
        title: "",
        desc: "",
        author: "",
        user: "",
        authorAvatar: "",
        publishDate: "",
        duration: 0,
        cover: "",
        filePath: "",
        fileName: "",
        isFavorite: false,
        favoriteAtDate: 0,
        lastStartDate: 0,
        lastPositionAtSecond: 0,
        lastPlayingAtDate: 0,
        userComments: "",
        rating: 0,
        dateCreated: 0,
        dateUpdated: 0
    )

    static let mock: AudioFileEntity = AudioFileEntity(
        uuid: "my-uuid",
        title: "Title",
        desc: "description",
        author: "Author",
        user: "User",
        authorAvatar: "https://yt3.ggpht.com/ytc/AIdro_lCJzsNsIMwjN0a86xcsvdAe2g1PKEU5JYgm1euOXHyCA=s176-c-k-c0x00ffffff-no-rj",
        publishDate: "",
        duration: 0,
        cover: "https://i.ytimg.com/vi_webp/BZN3bhZ8ixM/maxresdefault.webp",
        filePath: "",
        fileName: "",
        isFavorite: false,
        favoriteAtDate: 0,
        lastStartDate: 0,
        lastPositionAtSecond: 0,
        lastPlayingAtDate: 0,
        userComments: "",
        rating: 0,
        dateCreated: 0,
        dateUpdated: 0
    )
}
