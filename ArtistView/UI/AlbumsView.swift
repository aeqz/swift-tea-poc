//
//  AlbumsView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 4/11/22.
//

import AppKit

class AlbumsView: NSView, ViewProtocol, NSTableViewDelegate, NSTableViewDataSource {
    typealias Params = ()
    typealias State = AlbumsState
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

    private var albumsEntryViewIdentifier: NSUserInterfaceItemIdentifier {
        .init("albumsEntryView")
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

        return instance
    }
    
    func update(with state: State, issuer: Issuer<Message>) {
        self.issuer = issuer
        self.state = state
        position()
        table?.reloadData()
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        guard case let .loaded(entries) = state?.albumsLoad else {
            return 0
        }

        return entries[row].expanded
            ? 100
            : 40
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        guard case let .loaded(entries) = state?.albumsLoad else { return 0 }
        return entries.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard case let .loaded(entries) = state?.albumsLoad else {
            return nil
        }

        let view = tableView.makeView(
            withIdentifier: albumsEntryViewIdentifier,
            owner: self
        ) as? AlbumsEntryView ?? AlbumsEntryView.new(with: ())

        view.identifier = albumsEntryViewIdentifier
        view.update(
            with: entries[row],
            issuer: issuer?.cmap {
                .albumsEntry(
                    at: row,
                    message: $0
                )
            } ?? .void
        )

        return view
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if case let .loaded(entries) = state?.albumsLoad,
           row >= 0,
           row < entries.count {
            issuer?.issue(.init { $0(.toggle(at: row)) })
        }

        return false
    }
    
    private func position() {
        scroll?.frame = bounds
    }
}
