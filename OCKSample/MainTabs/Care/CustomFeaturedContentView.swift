//
//  CustomFeaturedContentView.swift
//  OCKSample
//
//  Created by Corey Baker on 4/17/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import UIKit
import CareKit
import CareKitUI

/// A simple subclass to take control of what CareKit already gives us.
class CustomFeaturedContentView: OCKFeaturedContentView {
    var url: URL?

    // Need to override so we can become delegate when the user taps on card
    override init(imageOverlayStyle: UIUserInterfaceStyle = .unspecified) {
        super.init(imageOverlayStyle: imageOverlayStyle)
        // Need to become a delegate so we know when view is tapped.
        self.delegate = self
    }

    convenience init(url: String, imageOverlayStyle: UIUserInterfaceStyle = .unspecified) {
        self.init(imageOverlayStyle: imageOverlayStyle) // This calls your local init
        // TODO: 1 - Need to turn the url string into a real URL using URL(string: String)

        // Need to become a delegate so we know when view is tapped.
        self.delegate = self
    }
}

/// Need to conform to delegate in order to be delegated to.
extension CustomFeaturedContentView: OCKFeaturedContentViewDelegate {

    @MainActor
    func didTapView(_ view: OCKFeaturedContentView) {
        // When tapped open a URL.
        guard let url = url else {
            return
        }
        UIApplication.shared.open(url)
    }
}
