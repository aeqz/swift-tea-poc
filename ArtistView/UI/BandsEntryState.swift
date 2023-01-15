//
//  BandsEntryState.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import Foundation

struct BandsEntryState: StateProtocol {
    typealias Params = Never
    typealias Message = Never

    let band: Band
    let selected: Bool

    static func initial(with params: Params) -> (BandsEntryState, Command<Never>?) {
    }

    func handle(message: Never) -> (BandsEntryState, Command<Never>?) {
    }
}
