//
//  PickedAppApp.swift
//  PickedApp
//
//  Created by Kevin Heredia on 8/4/25.
//

import SwiftUI

@main
struct PickedAppApp: App {
    @State var AppState = AppStateVM()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(AppState)
        }
    }
}
