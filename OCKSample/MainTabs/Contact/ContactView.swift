//
//  ContactView.swift
//  OCKSample
//
//  Created by Corey Baker on 11/25/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import UIKit
import CareKit
import CareKitStore
import os.log

/*
 You should notice this looks like CareView but with references
 to CustomContactViewController instead.
*/

struct ContactView: UIViewControllerRepresentable {

    @ObservedObject var viewModel = ContactViewModel()

    @MainActor
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = createViewContoller()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.backgroundColor = UIColor { $0.userInterfaceStyle == .light ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1): #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }

        return navigationController
    }

    @MainActor
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // swiftlint:disable:next force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if appDelegate.isFirstLogin && appDelegate.isFirstAppOpen {
            guard let navigationController = uiViewController as? UINavigationController,
                    // swiftlint:disable:next line_length
                    let currentViewController = navigationController.viewControllers.first as? CustomContactViewController,
                  appDelegate.storeManager !== currentViewController.storeManager  else {
                return
            }
            // Replace current view controller
            let viewController = createViewContoller()
            navigationController.viewControllers = [viewController]
        }
    }

    // MARK: Helpers
    func createViewContoller() -> UIViewController {
        guard let manager = StoreManagerKey.defaultValue else {
            Logger.contact.error("Couldn't unwrap storeManager")
            return CustomContactViewController(storeManager: .init(wrapping: OCKStore(name: "none_contact",
                                                                                      type: .inMemory)))
        }
        return CustomContactViewController(storeManager: manager)
    }
}

struct ContactView_Previews: PreviewProvider {

    static var previews: some View {
        ContactView()
    }
}
