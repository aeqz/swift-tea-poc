//
//  DetailHeaderState.swift
//  ArtistView
//
//  Created by Adri Enriquez on 4/11/22.
//

import Foundation

struct DetailHeaderState: StateProtocol {
    typealias Params = Never
    typealias Message = Never

    let band: Band

    static func initial(with params: Never) -> (DetailHeaderState, Command<Never>?) {
    }

    func handle(message: Never) -> (DetailHeaderState, Command<Never>?) {
    }
}
