//
//  LoadingView.swift
//  ArtistView
//
//  Created by Adri Enriquez on 2/11/22.
//

import AppKit

class LoadingView: NSView, ViewProtocol {
    typealias Params = ()
    typealias State = LoadingState
    typealias Message = State.Message
    typealias StateParams = State.Params

    private weak var progressIndicator: NSProgressIndicator?
    private weak var errorLabel: NSTextField?
    private weak var retryButton: NSButton?

    private var issuer: Issuer<Message>?
    private var animatingIndicator: Bool = false {
        didSet {
            guard oldValue != animatingIndicator else { return }
            if animatingIndicator {
                progressIndicator?.startAnimation(nil)
            } else {
                progressIndicator?.stopAnimation(nil)
            }
        }
    }

    override var frame: NSRect {
        didSet { position() }
    }

    override var bounds: NSRect {
        didSet { position() }
    }

    static func new(with params: Params) -> Self {
        let instance: Self = .init()

        instance.progressIndicator = instance.add(
            subview: .init()
        )

        instance.progressIndicator?.style = .spinning
        instance.progressIndicator?.appearance = NSAppearance(
            named: .vibrantLight
        )

        instance.errorLabel = instance.add(
            subview: .init()
        )

        instance.errorLabel?.labelize()
        instance.errorLabel?.stringValue = "Loading error"

        instance.retryButton = instance.add(
            subview: .init()
        )

        instance.retryButton?.target = instance
        instance.retryButton?.action = #selector(instance.onTapRetry)
        instance.retryButton?.title = "Retry"
        instance.retryButton?.bezelStyle = .rounded

        return instance
    }
    
    func update(with state: State, issuer: Issuer<Message>) {
        self.issuer = issuer

        switch state {
        case .loading:
            progressIndicator?.isHidden = false
            animatingIndicator = true
            errorLabel?.isHidden = true
            retryButton?.isHidden = true
        case .error:
            progressIndicator?.isHidden = true
            animatingIndicator = false
            errorLabel?.isHidden = false
            retryButton?.isHidden = false
        }

        position()
    }

    private func position() {
        errorLabel?.sizeToFit()
        errorLabel?.centerHorizontally(in: bounds)
        errorLabel?.top(in: bounds)

        retryButton?.sizeToFit()
        retryButton?.centerHorizontally(in: bounds)
        retryButton?.below(
            errorLabel?.frame ?? .zero,
            separation: 10
        )

        retryButton?.insetBy(dx: -2, dy: -2)

        centerSubviewsVertically()

        progressIndicator?.frame.size.width = 20
        progressIndicator?.frame.size.height = 20
        progressIndicator?.centerVertically(in: bounds)
        progressIndicator?.centerHorizontally(in: bounds)
    }

    @objc
    private func onTapRetry() {
        issuer?.issue(.init { $0(.retry) })
    }
}
