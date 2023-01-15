//
//  DetailView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 31/10/22.
//

import AppKit

class DetailView: NSView, ViewProtocol {
    typealias Params = ()
    typealias State = DetailState
    typealias Message = State.Message
    typealias StateParams = State.Params

    private weak var emptyLabel: NSTextField?
    private weak var bandNameLabel: NSTextField?
    private weak var headerView: DetailHeaderView?
    private weak var loadingView: LoadingView?
    private weak var albumsView: AlbumsView?

    override var frame: NSRect {
        didSet { position() }
    }

    override var bounds: NSRect {
        didSet { position() }
    }

    static func new(with params: Params) -> Self {
        let instance: Self = .init()

        instance.emptyLabel = instance.add(subview: .init())
        instance.emptyLabel?.labelize()
        instance.emptyLabel?.stringValue = "No band selected"
        instance.emptyLabel?.font = NSFont.systemFont(
            ofSize: 24,
            weight: .medium
        )

        instance.bandNameLabel = instance.add(subview: .init())
        instance.bandNameLabel?.labelize()
        instance.bandNameLabel?.font = NSFont.systemFont(
            ofSize: 24,
            weight: .medium
        )

        instance.headerView = instance.add(
            subview: .new(with: ())
        )

        instance.loadingView = instance.add(
            subview: .new(with: ())
        )

        instance.albumsView = instance.add(
            subview: .new(with: ())
        )

        return instance
    }
    
    func update(with state: State, issuer: Issuer<Message>) {
        switch state.bandSelection {
        case .notSelected:
            emptyLabel?.isHidden = false
            bandNameLabel?.isHidden = true
            loadingView?.isHidden = true
            headerView?.isHidden = true
            albumsView?.isHidden = true
        case let .selected(band, albums):
            emptyLabel?.isHidden = true
            bandNameLabel?.isHidden = false
            headerView?.isHidden = false

            bandNameLabel?.stringValue = band.name

            headerView?.update(
                with: .init(band: band),
                issuer: .void
            )

            albumsView?.update(
                with: albums,
                issuer: issuer.cmap {
                    .albums(
                        for: band,
                        message: $0
                    )
                }
            )

            switch albums.albumsLoad {
            case .loading:
                loadingView?.isHidden = false
                albumsView?.isHidden = true
                loadingView?.update(
                    with: .loading,
                    issuer: .void
                )
            case .error:
                loadingView?.isHidden = false
                albumsView?.isHidden = true
                loadingView?.update(
                    with: .error,
                    issuer: issuer.cmap {
                        _ in .retryLoadAlbums(
                            for: band
                        )
                    }
                )
            case .loaded:
                loadingView?.isHidden = true
                albumsView?.isHidden = false
            }
        }

        position()
    }
    
    private func position() {
        emptyLabel?.sizeToFit()
        emptyLabel?.centerHorizontally(in: bounds)
        emptyLabel?.centerVertically(in: bounds)

        bandNameLabel?.sizeToFit()
        bandNameLabel?.frame.origin.x = 15
        bandNameLabel?.top(
            in: bounds,
            after: 15
        )

        headerView?.frame.size.height = 100
        headerView?.frame.size.width = bounds.width
        headerView?.frame.origin.x = 0
        headerView?.below(
            bandNameLabel?.frame ?? .zero
        )

        headerView?.insetBy(dx: 15, dy: 15)

        loadingView?.frame.size.width = bounds.width
        loadingView?.frame.size.height = 80
        loadingView?.below(
            headerView?.frame ?? .zero,
            separation: 15
        )

        albumsView?.frame.origin.x = 0
        albumsView?.frame.size.width = bounds.width
        albumsView?.below(
            headerView?.frame ?? .zero,
            separation: 15
        )

        albumsView?.frame.size.height = albumsView?.frame.maxY
            ?? 0
    }
}
