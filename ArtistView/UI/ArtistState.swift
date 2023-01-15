//
//  ArtistState.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import Foundation

struct ArtistState: StateProtocol {
    struct Params {
        let pageLoadSize: Int
        let repository: Repository.Type
    }

    enum Message {
        case bands(BandsState.Message)
        case detail(
            message: DetailState.Message,
            at: Int?
        )
    }

    let bands: BandsState
    let detail: DetailState

    static func initial(with params: Params) -> (ArtistState, Command<Message>?) {
        let (bandsState, bandsCmd) = BandsState.initial(
            with: .init(
                pageLoadSize: params.pageLoadSize,
                repository: params.repository
            )
        )

        let (detailState, detailCmd) = DetailState.initial(
            with: .init(
                repository: params.repository
            )
        )

        return (
            .init(
                bands: bandsState,
                detail: detailState
            ),
            .batch(
                bandsCmd?.fmap(
                    with: Message.bands
                ),
                detailCmd?.fmap {
                    .detail(
                        message: $0,
                        at: bandsState.selected
                    )
                }
            )
        )
    }

    func handle(message: Message) -> (ArtistState, Command<Message>?) {
        switch message {
        case let .bands(.select(at)):
            guard bands.selected != at else { return (self, .none) }
            let (bands, bandsCmd) = bands.handle(
                message: .select(
                    at: at
                )
            )
            
            let (detail, detailCmd) = detail.handle(
                message: .select(
                    band: bands.bands[at]
                )
            )

            return (
                .init(
                    bands: bands,
                    detail: detail
                ),
                .batch(
                    bandsCmd?.fmap(
                        with: Message.bands
                    ),
                    detailCmd?.fmap {
                        .detail(
                            message: $0,
                            at: bands.selected
                        )
                    }
                )
            )
        case let .bands(message):
            let (bands, bandsCmd) = bands.handle(
                message: message
            )

            return (
                .init(
                    bands: bands,
                    detail: detail
                ),
                bandsCmd?.fmap(
                    with: Message.bands
                )
            )
        case let .detail(message, at):
            guard bands.selected == at else { return (self, .none) }
            let (detail, detailCmd) = detail.handle(
                message: message
            )

            return (
                .init(
                    bands: bands,
                    detail: detail
                ),
                detailCmd?.fmap {
                    .detail(
                        message: $0,
                        at: bands.selected
                    )
                }
            )
        }
    }
}
