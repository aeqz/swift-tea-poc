//
//  BandsState.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import Foundation

struct BandsState: StateProtocol {
    struct Params {
        let pageLoadSize: Int
        let repository: Repository.Type
    }

    enum Message {
        case select(
            at: Int
        )
        case loadMoreBands
        case gotMoreBands(
            bands: [Band]?
        )
    }

    enum Pagination {
        case loading, error, ended
    }

    let selected: Int?
    let bands: [Band]
    let pagination: Pagination?
    let pageLoadSize: Int
    let repository: Repository.Type

    static func initial(with params: Params) -> (BandsState, Command<Message>?) {
        (
            .init(
                selected: nil,
                bands: [],
                pagination: .loading,
                pageLoadSize: params.pageLoadSize,
                repository: params.repository
            ),
            params.repository.bands(
                from: 0,
                size: params.pageLoadSize,
                to: Message.gotMoreBands
            )
        )
    }

    func handle(message: Message) -> (BandsState, Command<Message>?) {
        switch message {
        case let .select(band):
            return (
                .init(
                    selected: band,
                    bands: bands,
                    pagination: pagination,
                    pageLoadSize: pageLoadSize,
                    repository: repository
                ),
                .none
            )
        case let .gotMoreBands(.some(moreBands)):
            return (
                .init(
                    selected: selected,
                    bands: bands + moreBands,
                    pagination: moreBands.count < pageLoadSize
                        ? .ended
                        : nil,
                    pageLoadSize: pageLoadSize,
                    repository: repository
                ),
                .none
            )
        case .gotMoreBands(.none):
            return (
                .init(
                    selected: selected,
                    bands: bands,
                    pagination: .error,
                    pageLoadSize: pageLoadSize,
                    repository: repository
                ),
                .none
            )
        case .loadMoreBands:
            switch pagination {
            case .ended, .loading:
                return (self, .none)
            case .none, .error:
                break
            }

            return (
                .init(
                    selected: selected,
                    bands: bands,
                    pagination: .loading,
                    pageLoadSize: pageLoadSize,
                    repository: repository
                ),
                repository.bands(
                    from: bands.count,
                    size: pageLoadSize,
                    to: Message.gotMoreBands
                )
            )
        }
    }
}
