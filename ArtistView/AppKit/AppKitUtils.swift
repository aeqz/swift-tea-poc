//
//  AppKitUtils.swift
//  ArtistView
//
//  Created by Adri Enriquez on 4/11/22.
//

import AppKit

/**
 Some utilities to work programatically with `AppKit` views in a simple way.
 */

extension NSView {
    func add<V: NSView>(subview: V) -> V {
        addSubview(subview)
        return subview
    }

    func centerSubviewsVertically() {
        let maxY = subviews.map { $0.bounds.maxY }.max() ?? 0
        let minY = subviews.map { $0.bounds.minY }.min() ?? 0
        let offset = (frame.height - (maxY - minY)) / 2
        subviews.forEach { $0.bounds.origin.y -= offset }
    }

    func insetBy(dx: CGFloat, dy: CGFloat) {
        frame = frame.insetBy(
            dx: dx,
            dy: dy
        )
    }

    func centerHorizontally(in other: NSRect) {
        frame.origin.x = other.origin.x + ceil((other.width - frame.width) / 2)
    }

    func centerVertically(in other: NSRect) {
        frame.origin.y = other.origin.y + ceil((other.height - frame.height) / 2)
    }

    func top(in other: NSRect, after margin: CGFloat = 0) {
        frame.origin.y = other.origin.y + other.height - frame.height - margin
    }

    func end(in other: NSRect) {
        frame.origin.x = other.origin.x + other.width - frame.width
    }

    func below(_ other: NSRect, separation: CGFloat = 0) {
        frame.origin.y = other.origin.y - separation - frame.height
    }

    func right(to other: NSRect, separation: CGFloat = 0) {
        frame.origin.x = other.origin.x + other.width + separation
    }
}

extension NSTextField {
    func labelize() {
        isBezeled = false
        drawsBackground = false
        isEditable = false
        isSelectable = false
    }
}
