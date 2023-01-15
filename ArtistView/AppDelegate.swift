//
//  AppDelegate.swift
//  ArtistView
//
//  Created by Adri Enriquez on 31/10/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow!

    private var run: Run<ArtistView>?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let node = window?.contentView else { return }
        
        // Run and render the `ArtistView` over the application root `node`.
        run = .init(
            with: (),
            and: .init(
                pageLoadSize: 40,
                repository: RepositoryMock.self
            ),
            at: node
        )
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
