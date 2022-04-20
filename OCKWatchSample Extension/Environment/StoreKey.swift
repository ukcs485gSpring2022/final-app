//
//  StoreKey.swift
//  OCKWatchSample Extension
//
//  Created by Corey Baker on 4/18/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import SwiftUI
import CareKitStore

struct StoreKey: EnvironmentKey {

    static var defaultValue: OCKStore? {
        // swiftlint:disable:next force_cast
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        return extensionDelegate.store
    }
}

extension EnvironmentValues {

    var store: OCKStore? {
        get {
            self[StoreKey.self]
        }

        set {
            self[StoreKey.self] = newValue
        }
    }
}
