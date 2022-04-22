//
//  MyContactView.swift
//  OCKSample
//
//  Created by Corey Baker on 4/21/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI

struct MyContactView: View {

    @StateObject var viewModel = MyContactViewModel()

    var body: some View {
        ScrollView {
            VStack {
                if let storeManager = viewModel.storeManager {
                    ForEach(viewModel.contacts, id: \.id) { contact in
                        DetailedContactView(contact: contact,
                                            storeManager: storeManager)
                        .padding(.horizontal)
                        // Technically, shouldn't hardcode a size,
                        // but leave the frame for the assignment.
                        .frame(width: 350, height: 350)
                    }
                }
                Spacer()
            }
        }
    }
}

struct MyContactView_Previews: PreviewProvider {
    static var previews: some View {
        MyContactView()
    }
}
