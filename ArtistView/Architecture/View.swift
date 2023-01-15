//
//  View.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//
import Foundation

/// A protocol for a view that receives a `State` for updating its content an can produce `Command`s.
protocol ViewProtocol<Params, State, StateParams, Message> {
    /// Initialization parameters.
    associatedtype Params

    /// Messages that its commands can produce for mutating the state.
    associatedtype Message

    /// State initialization parameters.
    associatedtype StateParams

    /// The view's state.
    associatedtype State: StateProtocol<StateParams, Message>

    /**
     Initialize the view given some `ViewProtocol.Params`.

     - Parameters:
        - with params: the initial view parameters.

     - Returns: the created view.

     */
    static func new(with params: Params) -> Self

    /**
     Tells a view to update with a given `ViewProtocol.State`.

     - Parameters:
        - with state: the new state.
        - issuer: a command listener for the view to produce them.

     */
    func update(with state: State, issuer: Issuer<Message>)
}
