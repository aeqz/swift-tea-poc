//
//  BandsView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 31/10/22.
//

import AppKit

class BandsView: NSView, ViewProtocol, NSTableViewDelegate, NSTableViewDataSource {
    typealias Params = ()
    typealias State = BandsState
    typealias Message = State.Message
    typealias StateParams = State.Params

    private weak var table: NSTableView?
    private weak var scroll: NSScrollView?

    override var frame: NSRect {
        didSet { position() }
    }

    override var bounds: NSRect {
        didSet { position() }
    }

    private var bandsEntryViewIdentifier: NSUserInterfaceItemIdentifier {
        .init("bandsEntryView")
    }

    private var loadingIdentifier: NSUserInterfaceItemIdentifier {
        .init("loading")
    }

    private var columnIdentifier: NSUserInterfaceItemIdentifier {
        .init("column")
    }

    private var issuer: Issuer<Message>?
    private var state: State?

    static func new(with params: Params) -> Self {
        let instance: Self = .init()
        instance.scroll = instance.add(subview: .init())

        let documentView: NSTableView = .init()
        instance.scroll?.documentView = documentView
        instance.scroll?.hasVerticalScroller = true
        instance.table = documentView
        instance.table?.delegate = instance
        instance.table?.dataSource = instance
        instance.table?.headerView = nil
        instance.table?.addTableColumn(
            .init(
                identifier: instance.columnIdentifier
            )
        )

        instance.scroll?.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(
            instance,
            selector: #selector(instance.checkLoadMore),
            name: NSView.boundsDidChangeNotification,
            object: instance.scroll?.contentView
        )

        return instance
    }

    func update(with state: State, issuer: Issuer<Message>) {
        self.issuer = issuer
        self.state = state
        position()
        table?.reloadData()
        checkLoadMore()
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        50
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let state = state else { return 0 }
        switch state.pagination {
        case .none,
                .some(.ended):
            return state.bands.count
        case .some(.error),
                .some(.loading):
            return state.bands.count + 1
        }
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let state = state, let issuer = issuer else { return nil }
        guard row < state.bands.count else {
            let loadingState: LoadingState
            switch state.pagination {
            case .loading:
                loadingState = .loading
            case .error:
                loadingState = .error
            case .ended, .none:
                return nil
            }

            let view = tableView.makeView(
                withIdentifier: loadingIdentifier,
                owner: self
            ) as? LoadingView ?? LoadingView.new(with: ())

            view.identifier = loadingIdentifier
            view.update(
                with: loadingState,
                issuer: issuer.cmap { _ in .loadMoreBands }
            )

            return view
        }

        let view = tableView.makeView(
            withIdentifier: bandsEntryViewIdentifier,
            owner: self
        ) as? BandsEntryView ?? BandsEntryView.new(with: ())

        view.identifier = bandsEntryViewIdentifier
        view.update(
            with: .init(
                band: state.bands[row],
                selected: row == state.selected
            ),
            issuer: .void
        )

        return view
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let state = state, row >= 0, row < state.bands.count {
            issuer?.issue(.init { $0(.select(at: row)) })
        }

        return false
    }

    private func position() {
        scroll?.frame = bounds
    }

    @objc 
    private func checkLoadMore() {
        guard state?.pagination == nil,
              let total = scroll?.contentView.documentRect,
              let visible = scroll?.contentView.documentVisibleRect,
              total.height - visible.height - visible.origin.y < visible.height else {
            return
        }

        issuer?.issue(.init { $0(.loadMoreBands) } )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
