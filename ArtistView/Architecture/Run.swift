//
//  Run.swift
//  ArtistView
//
//  Created by Adri Enriquez on 1/11/22.
//

import AppKit

/// A `ViewProtocol` runner.
class Run<V: ViewProtocol & NSView> {
    private weak var view: V?
    private weak var node: NSView?
    private weak var token: NSObjectProtocol?
    private var state: V.State {
        didSet { update() }
    }

    /**
     Initialise a new runner, which renders the specific `ViewProtocol` implementation `V` at a given `NSView` node.

     - Parameters:
        - with viewParams: params for initialising the view.
        - and stateParams: params for initialising the state.
        - at node: `NSView` node in which to render the view, stored weakly.

     */
    init(with viewParams: V.Params, and stateParams: V.StateParams, at node: NSView) {
        let v = V.new(with: viewParams)
        let (state, command) = V.State.initial(with: stateParams)

        self.node = node
        self.view = v
        self.state = state

        node.addSubview(v)
        v.frame = node.bounds
        node.postsFrameChangedNotifications = true
        token = NotificationCenter.default.addObserver(
            forName: NSView.frameDidChangeNotification,
            object: node,
            queue: .main
        ) { [weak v, weak node] _ in
            v?.frame = node?.bounds ?? .zero
        }

        command?.exec(self.handle)
        update()
    }

    private func update() {
        view?.update(
            with: state,
            issuer: .init { [weak self] command in
                command.exec { [weak self] message in
                    self?.handle(
                        message: message
                    )
                }
            }
        )
    }

    private func handle(message: V.Message) {
        let (state, command) = state.handle(
            message: message
        )

        self.state = state
        command?.exec { [weak self] message in
            self?.handle(
                message: message
            )
        }
    }

    deinit {
        token.map(NotificationCenter.default.removeObserver)
    }
}
