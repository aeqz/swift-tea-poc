//
//  ArtistView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 31/10/22.
//

import AppKit

class ArtistView: NSView, ViewProtocol {
    typealias Params = ()
    typealias State = ArtistState
    typealias Message = State.Message
    typealias StateParams = State.Params

    private weak var split: NSSplitView?
    private weak var bands: BandsView?
    private weak var detail: DetailView?

    override var frame: NSRect {
        didSet { position() }
    }

    override var bounds: NSRect {
        didSet { position() }
    }

    static func new(with params: Params) -> Self {
        let instance: Self = .init()
        instance.split = instance.add(
            subview: .init()
        )

        instance.split?.isVertical = true
        instance.split?.dividerStyle = .thin

        let bands = BandsView.new(with: ())
        instance.split?.addArrangedSubview(bands)
        instance.bands = bands

        let detail = DetailView.new(with: ())
        instance.split?.addArrangedSubview(detail)
        instance.detail = detail

        return instance
    }

    func update(with state: State, issuer: Issuer<Message>) {
        bands?.update(
            with: state.bands,
            issuer: issuer.cmap(
                with: Message.bands
            )
        )

        detail?.update(
            with: state.detail,
            issuer: issuer.cmap {
                .detail(
                    message: $0,
                    at: state.bands.selected
                )
            }
        )

        position()
    }

    private func position() {
        split?.frame = frame
    }
}
