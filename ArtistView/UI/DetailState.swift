//
//  DetailState.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import Foundation

struct DetailState: StateProtocol {
    struct Params {
        let repository: Repository.Type
    }

    enum Message {
        case select(
            band: Band
        )
        case retryLoadAlbums(
            for: Band
        )
        case albums(
            for: Band,
            message: AlbumsState.Message
        )
    }

    enum BandSelection {
        case notSelected
        case selected(
            band: Band,
            albums: AlbumsState
        )
    }

    let bandSelection: BandSelection
    let repository: Repository.Type

    static func initial(with params: Params) -> (DetailState, Command<Message>?) {
        (
            .init(
                bandSelection: .notSelected,
                repository: params.repository
            ),
            .none
        )
    }

    func handle(message: Message) -> (DetailState, Command<Message>?) {
        switch message {
        case let .select(band):
            let (albumsState, albumsCmd) = AlbumsState.initial(
                with: .init(
                    band: band,
                    repository: repository
                )
            )

            return (
                .init(
                    bandSelection: .selected(
                        band: band,
                        albums: albumsState
                    ),
                    repository: repository
                ),
                albumsCmd?.fmap {
                    .albums(
                        for: band,
                        message: $0
                    )
                }
            )
        case let .retryLoadAlbums(band):
            guard case let .selected(_, albums) = bandSelection,
                  case .error = albums.albumsLoad else {
                return (self, .none)
            }

            let (albumsState, albumsCmd) = AlbumsState.initial(
                with: .init(
                    band: band,
                    repository: repository
                )
            )

            return (
                .init(
                    bandSelection: .selected(
                        band: band,
                        albums: albumsState
                    ),
                    repository: repository
                ),
                albumsCmd?.fmap {
                    .albums(
                        for: band,
                        message: $0
                    )
                }
            )
        case let .albums(band, message):
            guard case let .selected(_, albums) = bandSelection else {
                return (self, .none)
            }

            let (albumsState, albumsCmd) = albums.handle(
                message: message
            )

            return (
                .init(
                    bandSelection: .selected(
                        band: band,
                        albums: albumsState
                    ),
                    repository: repository
                ),
                albumsCmd?.fmap {
                    .albums(
                        for: band,
                        message: $0
                    )
                }
            )
        }
    }
}
