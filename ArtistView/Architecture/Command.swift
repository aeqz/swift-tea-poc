//
//  Command.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import Foundation

/// A `Command` can perform side effects and emit `Message`s.
struct Command<Message> {
    /// Defines how the `Command` produces `Message`s for feeding a `Message` consumer.
    let exec: (@escaping (Message) -> Void) -> Void

    /**
     Transform the `Mesage`s that a `Command` produces with a given function.

     - Parameters:
        - with f: the function to apply to produced `Mesage`s.

     - Returns: the transformed `Command`.

     */
    func fmap<Other>(with f: @escaping (Message) -> Other) -> Command<Other> {
        .init { otherCallback in
            exec { message in
                otherCallback(f(message))
            }
        }
    }

    /**
     Join multiple `Command`s into a single `Command` in a variadric style.

     Parameters are `Optional` for the ease of using the `StateProtocol` produced `Command`s.

     - Parameters:
        - command: the first `Command` to join.
        - commands: the remaining `Command`s to join.

     - Returns: the joined parameter `Command`s into one single `Command`.

     */
    static func batch(_ command: Command<Message>?, _ commands: Command<Message>?...) -> Command<Message>? {
        guard let command = command else { return batch(of: commands) }
        return .init { batchCallback in
            command.exec(batchCallback)
            batch(of: commands)?.exec(batchCallback)
        }
    }

    /**
     Join multiple `Command`s into a single `Command`.

     Parameters are `Optional` for the ease of using the `StateProtocol` produced `Command`s.

     - Parameters:
        - of commands: the `Command`s to join.

     - Returns: the joined parameter `Command`s into one single `Command`.

     */
    static func batch(of commands: [Command<Message>?]) -> Command<Message>? {
        let commands = commands.compactMap { $0 }
        guard !commands.isEmpty else { return nil }
        return .init { batchCallback in
            commands.forEach { command in
                command.exec(batchCallback)
            }
        }
    }
}
