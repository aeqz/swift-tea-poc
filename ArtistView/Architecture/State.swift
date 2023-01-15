//
//  State.swift
//  ArtistView
//
//  Created by Adri Enriquez on 4/11/22.
//

import Foundation

/// A protocol for a state that defines how it can be initialized an how it can evolve.
protocol StateProtocol<Params, Message> {
    /// Initialization parameters.
    associatedtype Params

    /// Messages that can mutate it.
    associatedtype Message

    /**
     Initialize the state given some `StateProtocol.Params`.

     - Parameters:
        - with params: the initial state parameters.

     - Returns: a pair with the created state as the first component and maybe some command to execute.

     */
    static func initial(with params: Params) -> (Self, Command<Message>?)
    
    /**
     Produce a new state from the current one by handling a `StateProtocol.Message`.
     
     - Parameters:
        - message: the message to handle.

     - Returns: a pair with the new state as the first component and maybe some command to execute.

    */
    func handle(message: Message) -> (Self, Command<Message>?)
}
