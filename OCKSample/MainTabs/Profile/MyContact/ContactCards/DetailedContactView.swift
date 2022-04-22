//
//  DetailedContactView.swift
//  OCKSample
//
//  Created by Corey Baker on 4/21/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import UIKit
import CareKit
import CareKitUI
import CareKitStore
import os.log

struct DetailedContactView: UIViewControllerRepresentable {

    /// The contact to display.
    public let contact: OCKAnyContact

    /// The manager of the `Store` from which the `Contact` data is fetched.
    public let storeManager: OCKSynchronizedStoreManager

    func makeUIViewController(context: Context) -> some UIViewController {

        let contactCard = OCKDetailedContactViewController(contact: contact,
                                                           storeManager: storeManager)

        // Make sure this contact card matches app style when possible
        if let carekitView = contactCard.view as? OCKView {
            carekitView.customStyle = CustomStyleKey.defaultValue
        }
        return contactCard
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct DetailedContactView_Previews: PreviewProvider {

    static var previews: some View {
        DetailedContactView(contact: OCKContact(id: "",
                                                givenName: "hello",
                                                familyName: "world",
                                                carePlanUUID: nil),
                            storeManager: .init(wrapping: OCKStore(name: "dummy", type: .inMemory)))
    }
}
