//
//  Repository.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import Foundation

/// A protocol to query for artists data via `Command`s.
protocol Repository {
    /**
     Paginated existing `Band`s.
     */
    static func bands<Message>(
        from: Int,
        size: Int,
        to toMessage: @escaping ([Band]?) -> Message
    ) -> Command<Message>

    /**
     Paginated `Album`s for a `Band`.
     */
    static func albums<Message>(
        for: Band,
        to toMessage: @escaping ([Album]?) -> Message
    ) -> Command<Message>

    /**
     `Song`s of a `Band`'s `Album`.
     */
    static func songs<Message>(
        for: Band,
        at album: Album,
        to toMessage: @escaping ([Song]?) -> Message
    ) -> Command<Message>
}
