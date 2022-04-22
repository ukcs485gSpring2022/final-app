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

class MyContactViewModel: ObservableObject {

    @Published var contacts = [OCKAnyContact]()
    @Published var storeManager: OCKSynchronizedStoreManager?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewModel),
                                               name: Notification.Name(rawValue: Constants.storeInitialized),
                                               object: nil)
        if let storeManager = StoreManagerKey.defaultValue {
            self.storeManager = storeManager
            Task {
                try? await fetchMyContact()
            }
        }
    }

    // MARK: Helpers

    @objc private func reloadViewModel() {
        guard let storeManager = StoreManagerKey.defaultValue else {
            return
        }
        // If these stores don't have the same address in memory
        if self.storeManager !== storeManager {
            self.storeManager = storeManager
        }
        Task {
            try? await fetchMyContact()
        }
    }

    @MainActor
    func fetchMyContact() async throws {
        guard User.current != nil,
              let personUUIDString = UserDefaults.standard.object(forKey: Constants.parseRemoteClockIDKey) as? String,
              let storeManager = storeManager else {
            Logger.myContact.error("User not logged in")
            self.contacts.removeAll()
            return
        }

        // ToDo to get credit: How would you modify this query to only fetch the
        // contact that belongs to this device?
        /*
         Hint 1: There are multiple ways to do this. You can modify the query
         below which can work.
         
         Hint2: Look at the other queries in the app related to the uuid of the
         user who's signed in.
         
         Hint3: You should have a warning currently, solving this properly would
         get rid of the warning without changing the line the warning is on.
         */
        var query = OCKContactQuery(for: Date())
        query.sortDescriptors.append(.familyName(ascending: true))
        query.sortDescriptors.append(.givenName(ascending: true))

        self.contacts = try await storeManager.store.fetchAnyContacts(query: query)
     }
}
