//
//  UserProfileView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(AppStateVM.self) var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .padding(.top, 40)

                    Text(appState.userProfileData.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(appState.userProfileData.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(appState.userProfileData.role.capitalized)
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.primaryColor.opacity(0.1))
                        .foregroundColor(.primaryColor)
                        .clipShape(Capsule())

                    CustomButtonView(title: "Log Out", color: .primaryColor) {
                        Task {
                         await appState.closeSessionUser()
                        }
                    }
                    .padding(.top, 30)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("User Profile")
        }
    }
}


#Preview {
    UserProfileView()
        .environment(AppStateVM())
}
