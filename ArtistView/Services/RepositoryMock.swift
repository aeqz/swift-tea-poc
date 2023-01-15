//
//  RepositoryMock.swift
//  ArtistView
//
//  Created by Adri Enriquez on 28/11/22.
//

import Foundation

/// A mock `Repository` implementation with random data and a 0.25 failure rate.
struct RepositoryMock: Repository {
    private init() {}

    static func bands<Message>(
        from: Int,
        size: Int,
        to toMessage: @escaping ([Band]?) -> Message
    ) -> Command<Message> {
        .init { callback in
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
            ) {
                callback(
                    toMessage([
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        .none
                    ].randomElement()!)
                )
            }
        }
    }

    static func albums<Message>(
        for: Band,
        to toMessage: @escaping ([Album]?) -> Message
    ) -> Command<Message> {
        .init { callback in
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
            ) {
                callback(
                    toMessage([
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        .none
                    ].randomElement()!)
                )
            }
        }
    }

    static func songs<Message>(
        for: Band,
        at album: Album,
        to toMessage: @escaping ([Song]?) -> Message
    ) -> Command<Message> {
        .init { callback in
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2
            ) {
                callback(
                    toMessage([
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        (0...(0...100).randomElement()!)
                            .map { _ in .generate()},
                        .none
                    ].randomElement()!)
                )
            }
        }
    }
}
