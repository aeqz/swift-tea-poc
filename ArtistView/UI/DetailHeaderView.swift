//
//  DetailHeaderView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 4/11/22.
//

import AppKit

class DetailHeaderView: NSView, ViewProtocol {
    typealias Params = ()
    typealias State = DetailHeaderState
    typealias Message = State.Message
    typealias StateParams = State.Params

    private weak var bandGenreLabel: NSTextField?
    private weak var bandBiographyLabel: NSTextField?

    override var frame: NSRect {
        didSet { position() }
    }

    override var bounds: NSRect {
        didSet { position() }
    }

    static func new(with params: ()) -> Self {
        let instance: Self = .init()

        instance.bandGenreLabel = instance.add(subview: .init())
        instance.bandGenreLabel?.labelize()

        instance.bandBiographyLabel = instance.add(subview: .init())
        instance.bandBiographyLabel?.labelize()

        return instance
    }

    func update(with state: State, issuer: Issuer<Message>) {
        bandBiographyLabel?.stringValue = state.band.biography

        switch state.band.genre {
        case .djent:
            bandGenreLabel?.stringValue = "DJENT"
        case .jazz:
            bandGenreLabel?.stringValue = "JAZZ"
        case .prog:
            bandGenreLabel?.stringValue = "PROG"
        }

        position()
    }
    
    func position() {
        bandGenreLabel?.sizeToFit()
        bandGenreLabel?.top(in: bounds)

        bandBiographyLabel?.sizeToFit()
        bandBiographyLabel?.below(
            bandGenreLabel?.frame ?? .zero,
            separation: 4
        )

        centerSubviewsVertically()
    }
}
