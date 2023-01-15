//
//  Issuer.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import Foundation

/// A command listener that knows how to run `Command`s.
struct Issuer<Message> {
    /// Defines how the `Issuer` handles incomming `Command`s.
    let issue: (Command<Message>) -> Void

    /// An `Issuer` that discards every incomming `Command`.
    static var void: Issuer<Message> {
        .init { _ in return }
    }

    /**
     Transform the `Command`s that an `Issuer`can handle with a given function.

     - Parameters:
        - with f: the function to apply to incomming `Command`s.

     - Returns: the transformed `Issuer`.

     */
    func cmap<Other>(with f: @escaping (Other) -> Message) -> Issuer<Other> {
        .init { other in
            issue(other.fmap(with: f))
        }
    }
}
