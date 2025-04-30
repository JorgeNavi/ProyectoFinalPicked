//
//  AppTabBarView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 22/4/25.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State private var selection: String = "home"
    
    @State private var tabSelection: TabBarItem = .home
    
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            ConsumerView()
                .tabBarItem(tab: .home, selection: $tabSelection)
            
            LocationMapView()
                .tabBarItem(tab: .map, selection: $tabSelection)
            
            UserProfileView()
                .tabBarItem(tab: .profile, selection: $tabSelection)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    
    AppTabBarView()
        .environment(AppStateVM())
}


extension AppTabBarView {
    private var defaultTabView: some View {
        TabView(selection: $selection) {
            
            Color.red
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            Color.blue
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            
            Color.orange
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}
