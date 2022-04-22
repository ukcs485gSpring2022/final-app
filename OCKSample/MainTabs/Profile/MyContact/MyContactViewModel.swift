//
//  MyContactViewModel.swift
//  OCKSample
//
//  Created by Corey Baker on 4/21/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
import os.log
import CareKit

/*
 You should notice this looks like ContactViewModel.
*/

class MyContactViewModel: ObservableObject {
    @Published var update = false

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewModel),
                                               name: Notification.Name(rawValue: Constants.storeInitialized),
                                               object: nil)
    }

    // MARK: Helpers

    @objc private func reloadViewModel() {
        update = !update
    }
}
