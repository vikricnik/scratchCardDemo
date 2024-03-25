//
//  ScratchCard.swift
//  ScratchCardDemo
//
//  Created by Anton Brinda on 25/03/2024.
//

import Foundation
import SwiftData

@Model
final class ScratchCard {
    var scratched: Bool
    var uuid: String
    var ios: Double?

    init(scratched: Bool, uuid: String, ios: Double? = nil) {
        self.scratched = scratched
        self.uuid = uuid
    }
}

extension ScratchCard {

    var isActivated: Bool {
        (ios ?? 0) > 6.1
    }

}
