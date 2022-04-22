//
//  ProfileView.swift
//  OCKSample
//
//  Created by Corey Baker on 11/24/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import CareKitUI
import CareKitStore
import CareKit
import os.log

// swiftlint:disable multiple_closures_with_trailing_closure

struct ProfileView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userProfileViewModel) var viewModel
    @Environment(\.tintColor) private var tintColor
    @EnvironmentObject var userStatus: UserStatus
    @State var firstName = ""
    @State var lastName = ""
    @State var birthday = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
    @State var showContact = false
    @State var showingImagePicker = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $showContact,
                               destination: {
                    MyContactView()
                }) {
                    EmptyView()
                }
                if let image = viewModel.profileImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color(tintColor), lineWidth: 5))
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color(tintColor), lineWidth: 5))
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                }
                VStack(alignment: .leading) {
                    TextField("First Name", text: $firstName)
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)

                    TextField("Last Name", text: $lastName)
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)

                    DatePicker("Birthday", selection: $birthday, displayedComponents: [DatePickerComponents.date])
                        .padding()
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }

                // Notice that "action" is a closure (which is essentially
                // a function as argument like we discussed in class)
                Button(action: {

                    Task {
                        do {
                            try await viewModel.saveProfile(firstName,
                                                            last: lastName,
                                                            birth: birthday)
                        } catch {
                            Logger.profile.error("Error saving profile: \(error.localizedDescription)")
                        }
                    }

                }, label: {

                    Text("Save Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                })
                .background(Color(.green))
                .cornerRadius(15)

                // Notice that "action" is a closure (which is essentially
                // a function as argument like we discussed in class)
                Button(action: {
                    Task {
                        await viewModel.logout()
                    }

                }, label: {

                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                })
                .background(Color(.red))
                .cornerRadius(15)

                Spacer()
            }
            .navigationBarItems(trailing:
                             Button(action: {
                                 self.showContact = true
                             }) {
                                 Text("My Contact")
                             })
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: viewModel.$profileUIImage)
        }
        .onReceive(viewModel.$patient, perform: { patient in
            if let currentFirstName = patient?.name.givenName {
                firstName = currentFirstName
            }

            if let currentLastName = patient?.name.familyName {
                lastName = currentLastName
            }

            if let currentBirthday = patient?.birthday {
                birthday = currentBirthday
            }
        }).onReceive(viewModel.$isLoggedOut, perform: { value in
            if self.userStatus.isLoggedOut != value {
                self.userStatus.check()
            }
        }).onAppear(perform: {
            viewModel.refreshViewIfNeeded()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserStatus(isLoggedOut: false))
    }
}
