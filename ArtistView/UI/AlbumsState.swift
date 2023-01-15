//
//  AlbumsState.swift
//  ArtistView
//
//  Created by Adri Enriquez on 4/11/22.
//

import Foundation

struct AlbumsState: StateProtocol {
    struct Params {
        let band: Band
        let repository: Repository.Type
    }

    enum Message {
        case toggle(
            at: Int
        )
        case gotAlbums(
            albums: [Album]?,
            for: Band
        )
        case albumsEntry(
            at: Int,
            message: AlbumsEntryState.Message
        )
    }

    enum AlbumsLoad {
        case loading
        case error
        case loaded(
            entries: [AlbumsEntryState]
        )
    }

    let albumsLoad: AlbumsLoad
    let repository: Repository.Type

    static func initial(with params: Params) -> (AlbumsState, Command<Message>?) {
        (
            .init(
                albumsLoad: .loading,
                repository: params.repository
            ),
            params.repository.albums(
                for: params.band
            ) {
                .gotAlbums(
                    albums: $0,
                    for: params.band
                )
            }
        )
    }

    func handle(message: Message) -> (AlbumsState, Command<Message>?) {
        switch message {
        case let .toggle(at):
            guard case .loaded(var entries) = albumsLoad else {
                return (self, .none)
            }

            let state = entries[at]
            entries[at] = .init(
                band: state.band,
                album: state.album,
                songsLoad: state.songsLoad,
                expanded: !state.expanded,
                repository: state.repository
            )

            return (
                .init(
                    albumsLoad: .loaded(
                        entries: entries
                    ),
                    repository: repository
                ),
                .none
            )
        case let .gotAlbums(.some(albums), band):
            let statesAndCommands = albums.map {
                AlbumsEntryState.initial(
                    with: .init(
                        band: band,
                        album: $0,
                        repository: repository
                    )
                )
            }

            return (
                .init(
                    albumsLoad: .loaded(
                        entries: statesAndCommands.map {
                            $0.0
                        }
                    ),
                    repository: repository
                ),
                .batch(
                    of: statesAndCommands
                        .lazy
                        .enumerated()
                        .map { data in
                            data.element.1?.fmap {
                                .albumsEntry(
                                    at: data.offset,
                                    message: $0
                                )
                            }
                        }
                )
            )
        case .gotAlbums(.none, _):
            return (
                .init(
                    albumsLoad: .error,
                    repository: repository
                ),
                .none
            )
        case let .albumsEntry(at, message):
            guard case .loaded(var entries) = albumsLoad else {
                return (self, .none)
            }

            let state = entries[at]
            let (entryState, entryCommand) = state.handle(
                message: message
            )

            entries[at] = entryState
            return (
                .init(
                    albumsLoad: .loaded(
                        entries: entries
                    ),
                    repository: repository
                ),
                entryCommand?.fmap {
                    .albumsEntry(
                        at: at,
                        message: $0
                    )
                }
            )
        }
    }
}
