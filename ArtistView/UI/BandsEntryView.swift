//
//  BandsEntryView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import AppKit

class BandsEntryView: NSView, ViewProtocol {
    typealias Params = ()
    typealias State = BandsEntryState
    typealias Message = State.Message
    typealias StateParams = State.Params

    private weak var bandNameLabel: NSTextField?
    private weak var bandGenreLabel: NSTextField?

    override var frame: NSRect {
        didSet { position() }
    }

    override var bounds: NSRect {
        didSet { position() }
    }

    static func new(with params: Params) -> Self {
        let instance: Self = .init()

        instance.wantsLayer = true
        instance.bandNameLabel = instance.add(subview: .init())
        instance.bandNameLabel?.labelize()

        instance.bandGenreLabel = instance.add(subview: .init())
        instance.bandGenreLabel?.labelize()

        return instance
    }

    func update(with state: State, issuer: Issuer<Message>) {
        bandNameLabel?.stringValue = state.band.name

        switch state.band.genre {
        case .djent:
            bandGenreLabel?.stringValue = "DJENT"
        case .jazz:
            bandGenreLabel?.stringValue = "JAZZ"
        case .prog:
            bandGenreLabel?.stringValue = "PROG"
        }

        layer?.backgroundColor = state.selected
            ? NSColor.systemBlue.cgColor
            : nil

        position()
    }

    private func position() {
        bandNameLabel?.sizeToFit()
        bandNameLabel?.top(in: bounds)
        bandNameLabel?.frame.origin.x = 0

        bandGenreLabel?.sizeToFit()
        bandGenreLabel?.frame.origin.x = 0
        bandGenreLabel?.below(
            bandNameLabel?.frame ?? .zero,
            separation: 10
        )

        centerSubviewsVertically()
    }
}
