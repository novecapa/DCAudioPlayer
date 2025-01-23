//
//  SDAudioFile.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import Foundation
import SwiftData

@Model
final class SDAudioFile {
    @Attribute(.unique) var uuid: String
    var title: String
    var desc: String
    var author: String
    var user: String
    var authorAvatar: String
    var publishDate: String
    var duration: Double
    var cover: String
    var fileName: String

    var isFavorite: Bool = false
    var favoriteAtDate: Double = 0

    var lastStartDate: Double = 0
    var lastPositionAtSecond: Double = 0
    var lastPlayingAtDate: Double = 0

    var userComments: String = ""
    var rating: Int = 0

    var dateCreated: Double
    var dateUpdated: Double = 0

    init(
        uuid: String,
        title: String,
        desc: String,
        author: String,
        user: String,
        authorAvatar: String,
        publishDate: String,
        duration: Double,
        cover: String,
        fileName: String,
        dateCreated: Double
    ) {
        self.uuid = uuid
        self.title = title
        self.desc = desc
        self.author = author
        self.user = user
        self.authorAvatar = authorAvatar
        self.publishDate = publishDate
        self.duration = duration
        self.cover = cover
        self.fileName = fileName
        self.dateCreated = dateCreated
    }
}
