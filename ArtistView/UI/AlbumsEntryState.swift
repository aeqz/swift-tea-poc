//
//  AlbumsEntryState.swift
//  HistoryView
//
//  Created by Adri Enriquez on 4/11/22.
//

import Foundation

struct AlbumsEntryState: StateProtocol {
    struct Params {
        let band: Band
        let album: Album
        let repository: Repository.Type
    }

    enum Message {
        case retryLoadSongs
        case gotSongs(
            songs: [Song]?
        )
    }

    enum SongsLoad {
        case loading, error, loaded(songs: [Song])
    }

    let band: Band
    let album: Album
    let songsLoad: SongsLoad
    let expanded: Bool
    let repository: Repository.Type

    static func initial(with params: Params) -> (AlbumsEntryState, Command<Message>?) {
        (
            .init(
                band: params.band,
                album: params.album,
                songsLoad: .loading,
                expanded: false,
                repository: params.repository
            ),
            params.repository.self.songs(
                for: params.band,
                at: params.album
            ) {
                .gotSongs(
                    songs: $0
                )
            }
        )
    }

    func handle(message: Message) -> (AlbumsEntryState, Command<Message>?) {
        switch message {
        case .retryLoadSongs:
            guard case .error = songsLoad else {
                return (self, .none)
            }

            return (
                .init(
                    band: band,
                    album: album,
                    songsLoad: .loading,
                    expanded: expanded,
                    repository: repository
                ),
                repository.songs(
                    for: band,
                    at: album
                ) {
                    .gotSongs(
                        songs: $0
                    )
                }
            )
        case let .gotSongs(.some(songs)):
            guard case .loading = songsLoad else {
                return (self, .none)
            }

            return (
                .init(
                    band: band,
                    album: album,
                    songsLoad: .loaded(
                        songs: songs
                    ),
                    expanded: expanded,
                    repository: repository
                )
                , .none
            )
        case .gotSongs(.none):
            guard case .loading = songsLoad else {
                return (self, .none)
            }

            return (
                .init(
                    band: band,
                    album: album,
                    songsLoad: .error,
                    expanded: expanded,
                    repository: repository
                ),
                .none
            )
        }
    }
}
