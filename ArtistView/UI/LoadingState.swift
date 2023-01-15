//
//  LoadingState.swift
//  ArtistView
//
//  Created by Adri Enriquez on 2/11/22.
//

import Foundation

enum LoadingState: StateProtocol {
    typealias Params = Never

    enum Message {
        case retry
    }

    case loading, error
    
    static func initial(with params: Params) -> (LoadingState, Command<Message>?) {
    }

    func handle(message: Message) -> (LoadingState, Command<Message>?) {
        switch (message, self) {
        case (.retry, .loading):
            return (.loading, .none)
        case (.retry, .error):
            return (.loading, .none)
        }
    }
}
