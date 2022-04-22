//
//  MyContactView.swift
//  OCKSample
//
//  Created by Corey Baker on 4/21/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import UIKit
import CareKit
import CareKitStore
import os.log

/*
 You should notice this looks like ContactView but with references
 to MyContactViewController instead.
*/

struct MyContactView: UIViewControllerRepresentable {

    @ObservedObject var viewModel = MyContactViewModel()

    @MainActor
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = createViewContoller()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.backgroundColor = UIColor { $0.userInterfaceStyle == .light ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1): #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }

    @MainActor
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // swiftlint:disable:next force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if appDelegate.isFirstLogin && appDelegate.isFirstAppOpen {
            guard let navigationController = uiViewController as? UINavigationController,
                    let currentViewController = navigationController.viewControllers.first as? MyContactViewController,
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
            Logger.myContact.error("Couldn't unwrap storeManager")
            return MyContactViewController(storeManager: .init(wrapping: OCKStore(name: "none_my_contact",
                                                                                  type: .inMemory)))
        }
        return MyContactViewController(storeManager: manager)
    }
}

struct MyContactView_Previews: PreviewProvider {
    static var previews: some View {
        MyContactView()
    }
}
