//
//  AlbumsEntryView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 4/11/22.
//

import AppKit

class AlbumsEntryView: NSView, ViewProtocol {
    typealias Params = ()
    typealias State = AlbumsEntryState
    typealias Message = State.Message
    typealias StateParams = State.Params

    private weak var albumTitleLabel: NSTextField?
    private weak var albumDateLabel: NSTextField?
    private weak var loadingView: LoadingView?
    private weak var songsLabel: NSTextField?

    override var frame: NSRect {
        didSet { position() }
    }

    override var bounds: NSRect {
        didSet { position() }
    }

    static func new(with params: Params) -> Self {
        let instance: Self = .init()

        instance.wantsLayer = true
        instance.albumTitleLabel = instance.add(subview: .init())
        instance.albumTitleLabel?.labelize()

        instance.albumDateLabel = instance.add(subview: .init())
        instance.albumDateLabel?.labelize()

        instance.loadingView = instance.add(subview: .new(with: ()))

        instance.songsLabel = instance.add(subview: .init())
        instance.songsLabel?.labelize()

        return instance
    }

    func update(with state: State, issuer: Issuer<Message>) {
        albumTitleLabel?.stringValue = state.album.title

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        albumDateLabel?.stringValue = formatter.string(from: state.album.date)

        switch state.songsLoad {
        case .loading:
            loadingView?.isHidden = !state.expanded
            songsLabel?.isHidden = true
            loadingView?.update(
                with: .loading,
                issuer: .void
            )
        case .error:
            loadingView?.isHidden = !state.expanded
            songsLabel?.isHidden = true
            loadingView?.update(
                with: .error,
                issuer: issuer.cmap { _ in
                    .retryLoadSongs
                }
            )
        case let .loaded(songs):
            loadingView?.isHidden = true
            songsLabel?.isHidden = !state.expanded
            songsLabel?.stringValue = songs.lazy
                .map { "• \($0.name)" }
                .joined(separator: "\n")
        }

        position()
    }
    
    private func position() {
        albumTitleLabel?.sizeToFit()
        albumTitleLabel?.top(in: bounds)
        albumTitleLabel?.frame.origin.x = 0

        albumDateLabel?.sizeToFit()
        albumDateLabel?.top(in: bounds)
        albumDateLabel?.right(
            to: albumTitleLabel?.frame ?? .zero,
            separation: 10
        )

        loadingView?.frame.size.width = bounds.width
        loadingView?.frame.size.height = albumDateLabel?.frame.minY ?? 0
        loadingView?.frame.origin.x = 0
        loadingView?.below(
            albumDateLabel?.frame ?? .zero
        )

        loadingView?.insetBy(
            dx: 0,
            dy: 10
        )

        songsLabel?.sizeToFit()
        songsLabel?.frame.size.width = bounds.width
        songsLabel?.frame.size.height = albumDateLabel?.frame.minY ?? 0
        songsLabel?.frame.origin.x = 0
        songsLabel?.below(
            albumDateLabel?.frame ?? .zero
        )

        songsLabel?.insetBy(
            dx: 0,
            dy: 10
        )
    }
}
