//
//  TestData.swift
//  ArtistView
//
//  Created by Adri Enriquez on 2/11/22.
//

import Foundation

protocol TestData {
    static func generate() -> Self
}

extension Band: TestData {
    static func generate() -> Band {
        .init(
            name: [
                "Meshuggah",
                "Periphery",
                "Tesseract",
                "Thundercat"
            ].randomElement()!,
            biography: [
"""
Mock bio.
"""
            ].randomElement()!,
            genre: .generate()
        )
    }
}

extension Band.Genre: TestData {
    static func generate() -> Band.Genre {
        [
            .djent,
            .jazz,
            .prog
        ].randomElement()!
    }
}

extension Album: TestData {
    static func generate() -> Album {
        .init(
            title: [
                "Periphery",
                "obZen",
                "Drunk"
            ].randomElement()!,
            date: Date(
                timeIntervalSince1970: Double.random(
                    in: 0...Date().timeIntervalSince1970
                )
            )
        )
    }
}

extension Song: TestData {
    static func generate() -> Song {
        .init(
            name: [
                "Bleed",
                "Racecar",
                "A fan’s mail (tron song suite ii)",
            ].randomElement()!
        )
    }
}
