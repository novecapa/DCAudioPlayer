//
//  ddd.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 25/1/25.
//

@testable import DCAudioPlayer

extension SDAudioFile {
    static let mock = SDAudioFile(
        uuid: "uuid",
        title: "title",
        desc: "desc",
        author: "author",
        user: "user",
        authorAvatar: "authorAvatar",
        publishDate: "publishDate",
        duration: 1200,
        cover: "cover",
        fileName: "fileName",
        dateCreated: 17888912
    )
}
